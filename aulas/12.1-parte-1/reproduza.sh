#!/usr/bin/env bash
# Aula 12.1, Parte 1: Entrar com Google num app web: o ID token e três erros.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
curl -s https://accounts.google.com/.well-known/openid-configuration | tr -d ' \n' | grep -o -E '"(issuer|jwks_uri|subject_types_supported|authorization_response_iss_parameter_supported)":(\[[^]]*\]|[^,}]*)'
curl -s -D - -o /dev/null https://www.googleapis.com/oauth2/v3/certs | grep -i cache-control
# 2. Uma loja mínima (5630) e um emissor do curso (NÃO é o Google: as chaves são daqui)
echo; echo "== 2. Uma loja mínima (5630) e um emissor do curso (NÃO é o Google: as chaves são daqui)"
node -e 'var C=require("crypto"),k=C.generateKeyPairSync("rsa",{modulusLength:2048}),LOJA="000000000001-loja.apps.googleusercontent.com";
function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}function ag(){return Date.now()/1e3|0}
function emite(c){var h=b({alg:"RS256",kid:"curso"}),p=b(c);return h+"."+p+"."+C.sign("sha256",Buffer.from(h+"."+p),k.privateKey).toString("base64url")}
function le(t){var x=String(t).split(".");try{if(C.verify("sha256",Buffer.from(x[0]+"."+x[1]),k.publicKey,Buffer.from(x[2],"base64url")))return JSON.parse(Buffer.from(x[1],"base64url"))}catch(e){}return 0}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var u=new URL(r.url,"http://x"),q=u.searchParams,c;
function j(st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
if(u.pathname=="/emissor")return j(200,{id_token:emite({iss:"https://accounts.google.com",aud:q.get("aud"),sub:q.get("sub"),email:q.get("email"),hd:q.get("hd")||undefined,exp:ag()+3600})});
c=le(new URLSearchParams(t).get("credential"));if(c)0;else return j(401,{erro:"assinatura"});
if(["https://accounts.google.com","accounts.google.com"].indexOf(c.iss)+1)0;else return j(401,{erro:"iss"});
if(Math.max(0,ag()-c.exp))return j(401,{erro:"exp"});
if(u.pathname=="/ingenua")return j(200,{loja:"ingenua",entrou_como:c.email});
if(c.aud==LOJA)0;else return j(401,{loja:"certa",erro:"aud: o token era de outro app"});
if(u.pathname=="/equipe")if(c.hd=="lojadomarcos.test")0;else return j(403,{erro:"sem o dominio da empresa no token"});
j(200,{loja:"certa",entrou:c.sub,email:c.email})})}).listen(5630,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5630; v() { sed 's/.*"id_token":"//;s/".*//'; }; A=000000000001-loja.apps.googleusercontent.com; T="$S/emissor?sub=104729384756102938475"
J=$(curl -s "$T&aud=000000000002-jogos.apps.googleusercontent.com&email=bia@correio.test" | v)
L=$(curl -s "$T&aud=$A&email=bia@correio.test" | v)
# 3. O token do app de jogos (outro aud): a ingênua deixa entrar, a certa recusa; o da loja entra
echo; echo "== 3. O token do app de jogos (outro aud): a ingênua deixa entrar, a certa recusa; o da loja entra"
curl -s $S/ingenua -d "credential=$J"; curl -s $S/certa -d "credential=$J"; curl -s $S/certa -d "credential=$L"
# 4. Área da equipe: sem o domínio no token, 403; com ele, entra
echo; echo "== 4. Área da equipe: sem o domínio no token, 403; com ele, entra"
E=$(curl -s "$S/emissor?sub=113355779911224466880&aud=$A&email=eva@correio.test" | v)
K=$(curl -s "$S/emissor?sub=109876543210987654321&aud=$A&email=carla@lojadomarcos.test&hd=lojadomarcos.test" | v)
curl -s $S/equipe -d "credential=$E"; curl -s $S/equipe -d "credential=$K"
kill %1
