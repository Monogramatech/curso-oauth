#!/usr/bin/env bash
# Aula 12.7, Parte 1: Entra e Keycloak: a ponte entre provedores (RFC 7523).
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.7-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var http=require("http"),c=require("crypto"),K={entra:c.randomBytes(32),sts:c.randomBytes(32)},U={},KC="http://127.0.0.1:5860/kc",LIGA={"entra|par-ops":"bia","sts|e756bc21":"bia"};
function b(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function mac(k,h){return c.createHmac("sha256",K[k]).update(h).digest("base64url")}
function assina(o){var h=b({alg:"HS256"})+"."+b(o);return h+"."+mac(o.iss,h)}
function le(t){try{var p=t.split("."),o=JSON.parse(Buffer.from(p[1],"base64url"));if(mac(o.iss,p[0]+"."+p[1])==p[2])return o}catch(e){}}
http.createServer(function(q,s){var u=new URL(q.url,"http://x"),g=function(k){return u.searchParams.get(k)},d="";q.on("data",function(x){d+=x});q.on("end",function(){
var p=new URLSearchParams(d),j=function(st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")},t=Math.floor(Date.now()/1000),f=function(m){j(400,{error:"invalid_grant",error_description:m})};
if(u.pathname=="/entra")return j(200,{token:assina({iss:"entra",aud:"guid-"+g("para"),sub:"par-"+g("para"),oid:"e756bc21",scp:"Ops.Access",uti:c.randomUUID(),iat:t,exp:t+4500})});
if(u.pathname=="/sts"){var e=le(p.get("token"));if(e&&e.iss=="entra"&&e.aud=="guid-sts")0;else return j(401,{error:"invalid_token",error_description:"emitido para outro app"});
return j(200,{assertion:assina({iss:"sts",sub:e.oid,aud:KC,jti:c.randomUUID(),iat:t,exp:t+60,scope:"estoque:ler"})})}
var x=le(p.get("assertion"));if(x&&x.exp-t+1)0;else return f("Token is not active");
if(g("reuso"))0;else{if(x.jti)0;else return f("Token jti claim is required");if(U[x.jti])return f("Token reuse detected");U[x.jti]=1}
if(x.aud==KC||g("aud")&&x.aud=="guid-ops")0;else return f("Invalid token audience");
var quem=LIGA[x.iss+"|"+x.sub],pede=p.get("scope")||"estoque:ler";if(quem)0;else return f("User not found");
if(x.iss=="sts"&&(pede==x.scope)==false)return j(400,{error:"invalid_scope",error_description:"not present in the initial access token"});
j(200,{pessoa:quem,aud:"api-estoque",scope:pede,expires_in:300,refresh_token:null})})}).listen(5860,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5860; v(){ sed "s/.*\"$1\":\"\([^\"]*\)\".*/\1/" $2; }; k(){ curl -s -d "assertion=$1$3" "$S/kc$2"; }
# 1. O token do Entra direto: falta o jti; com o reuso, a audiência; com as duas concessões, passa, e passa de novo
echo; echo "== 1. O token do Entra direto: falta o jti; com o reuso, a audiência; com as duas concessões, passa, e passa de novo"
curl -s "$S/entra?para=ops" | tee /tmp/e; E=$(v token /tmp/e); k $E; k $E "?reuso=1"; k $E "?reuso=1&aud=1"; k $E "?reuso=1&aud=1"
# 2. O STS de fronteira: recusa o token emitido para outro app; com o token certo, emite a assertion da RFC
echo; echo "== 2. O STS de fronteira: recusa o token emitido para outro app; com o token certo, emite a assertion da RFC"
curl -s -d "token=$E" $S/sts; curl -s "$S/entra?para=sts" | tee /tmp/e2; F=$(v token /tmp/e2); curl -s -d "token=$F" $S/sts | tee /tmp/a
# 3. O receptor aceita uma vez; a mesma assertion de novo cai; pedir o ajuste cai (só o escopo da assertion)
echo; echo "== 3. O receptor aceita uma vez; a mesma assertion de novo cai; pedir o ajuste cai (só o escopo da assertion)"
k $(v assertion /tmp/a); k $(v assertion /tmp/a); curl -s -d "token=$F" $S/sts | tee /tmp/a; k $(v assertion /tmp/a) "" "&scope=estoque:ler estoque:ajustar"
kill %1
