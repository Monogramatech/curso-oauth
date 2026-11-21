#!/usr/bin/env bash
# Aula 11.1, Parte 1: Identidade própria para o agente e o agente no act.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/11.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),h=require("http"),k=C.generateKeyPairSync("ec",{namedCurve:"P-256"}),off=0,ag=["assistente"];
function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}function q(s,c,o){s.writeHead(c);s.end(JSON.stringify(o)+"\n")}
function tk(c){var n=Date.now()/1e3|0;c.iat=n;c.exp=n+300;var e=b({alg:"ES256"})+"."+b(c);return e+"."+C.sign("sha256",Buffer.from(e),{key:k.privateKey,dsaEncoding:"ieee-p1363"}).toString("base64url")}
function ok(t){var x=String(t).split("."),c;try{c=JSON.parse(Buffer.from(x[1],"base64url"))}catch(e){return 0}return C.verify("sha256",Buffer.from(x[0]+"."+x[1]),{key:k.publicKey,dsaEncoding:"ieee-p1363"},Buffer.from(x[2],"base64url"))&&c}
h.createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var a=new URL(r.url,"http://x").pathname,p=new URLSearchParams(t);
if(a=="/login")return q(s,200,{t:tk({sub:"bia",azp:"portal",aud:["pedidos","pagamentos","assistente"]})});
if(a=="/cc")return off?q(s,401,{error:"invalid_client"}):q(s,200,{t:tk({sub:"svc-assistente",azp:"assistente",client_id:"assistente",aud:["pedidos"]})});
if(a=="/desliga"){off=1;return q(s,200,{desligado:"assistente"})}
if(a=="/troca"){var S=ok(p.get("s")),A=ok(p.get("a"));if(S&&A)0;else return q(s,400,{error:"invalid_request"});return q(s,200,{t:tk({sub:S.sub,aud:["pagamentos","pedidos"],act:{client_id:A.client_id}})})}
var c=ok((r.headers.authorization||"").slice(7));if(c)0;else return q(s,401,{error:"invalid_token"});
var g=c.act?c.act.client_id+" (act)":ag.indexOf(c.azp)+1?c.azp+" (azp)":"nenhum",L={pessoa:c.client_id?null:c.sub,agente:g};
if(c.client_id)return q(s,403,{registro:L,motivo:"sem pessoa"});if(a=="/estornos"&&g.indexOf("(")+1)return q(s,403,{registro:L,motivo:"agente: pede a confirmação da pessoa"});
q(s,a=="/estornos"?201:200,{registro:L})})}).listen(5470)' &
sleep 2
v() { sed 's/.*"t":"//;s/".*//'; }; S=localhost:5470; P=$(curl -s $S/login | v); A=$(curl -s $S/cc | v)
# 1. O repasse: o agente usa o token da Bia; a API não vê o agente, e o estorno passa (201)
echo; echo "== 1. O repasse: o agente usa o token da Bia; a API não vê o agente, e o estorno passa (201)"
curl -s -X POST $S/estornos -H "Authorization: Bearer $P"
# 2. A troca com o token do agente como ator: a API vê o agente pela claim act e recusa o estorno (403)
echo; echo "== 2. A troca com o token do agente como ator: a API vê o agente pela claim act e recusa o estorno (403)"
X=$(curl -s $S/troca -d "s=$P&a=$A" | v); curl -s -X POST $S/estornos -H "Authorization: Bearer $X"
# 3. O agente sozinho não é a Bia (403); desligado, não ganha token novo (401), mas o que já tinha ainda passa (200)
echo; echo "== 3. O agente sozinho não é a Bia (403); desligado, não ganha token novo (401), mas o que já tinha ainda passa (200)"
curl -s $S/pedidos -H "Authorization: Bearer $A"; curl -s -X POST $S/desliga; curl -s $S/cc; curl -s $S/pedidos -H "Authorization: Bearer $X"
kill %1
