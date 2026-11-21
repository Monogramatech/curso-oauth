#!/usr/bin/env bash
# Aula 12.4, Parte 1: Client credentials em produção: um client por sistema e a chave vazada.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.4-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),http=require("http"),K={},pub=[],cache={},ultima=0,buscas=0;
function b64(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function jwk(k){var j=C.createPublicKey(K[k]).export({format:"jwk"});j.kid=k;return j}
http.createServer(function(q,s){var u=new URL(q.url,"http://x"),k=u.searchParams.get("kid");
if(u.pathname=="/jwks.json")return s.end(JSON.stringify({keys:pub.map(jwk)}));
if(u.pathname=="/publica"){pub=u.searchParams.get("kids").split(",");pub.forEach(function(x){K[x]=K[x]||C.generateKeyPairSync("rsa",{modulusLength:2048}).privateKey});return s.end(JSON.stringify({lista:pub})+"\n")}
var t=Date.now()/1e3|0,c=b64({alg:"RS256",kid:k})+"."+b64({iss:"job",sub:"job",iat:t,exp:t+60}),a=c+"."+C.sign("sha256",Buffer.from(c),K[k]).toString("base64url");
fetch("http://127.0.0.1:5830/token",{method:"POST",body:a}).then(function(r){return r.text()}).then(function(x){s.end(x)})}).listen(5831,"127.0.0.1");
http.createServer(function(q,s){var b="";q.on("data",function(d){b+=d});q.on("end",function(){var x=b.split("."),h=JSON.parse(Buffer.from(x[0],"base64url"));
function fim(j){var ok=j&&C.verify("sha256",Buffer.from(x[0]+"."+x[1]),C.createPublicKey({key:j,format:"jwk"}),Buffer.from(x[2],"base64url"));
s.end(JSON.stringify(ok?{status:200,kid:h.kid,buscas:buscas}:{status:400,kid:h.kid,erro:"Unable to load public key",buscas:buscas})+"\n")}
if(cache[h.kid])return fim(cache[h.kid]);
if(Math.max(0,Date.now()-ultima-1e4)==0)return fim(0);
ultima=Date.now();buscas++;fetch("http://127.0.0.1:5831/jwks.json").then(function(r){return r.json()}).then(function(js){cache={};js.keys.forEach(function(j){cache[j.kid]=j});fim(cache[h.kid])})})}).listen(5830,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5831
# 1. O job publica a chave A e pede um token: o emissor busca a lista e guarda a A pelo kid
echo; echo "== 1. O job publica a chave A e pede um token: o emissor busca a lista e guarda a A pelo kid"
curl -s "$S/publica?kids=A"; curl -s "$S/token?kid=A"
# 2. A troca logo depois de uma busca: a B leva 400; depois de 10 s, passa
echo; echo "== 2. A troca logo depois de uma busca: a B leva 400; depois de 10 s, passa"
curl -s "$S/publica?kids=A,B"; curl -s "$S/token?kid=B"; sleep 11; curl -s "$S/token?kid=B"
# 3. A A vazou e sai da lista: a cópia da A ainda passa (está no cache)
echo; echo "== 3. A A vazou e sai da lista: a cópia da A ainda passa (está no cache)"
curl -s "$S/publica?kids=B"; curl -s "$S/token?kid=A"
# 4. O job passa à chave C (uma busca nova): a A cai junto
echo; echo "== 4. O job passa à chave C (uma busca nova): a A cai junto"
sleep 11; curl -s "$S/publica?kids=B,C"; curl -s "$S/token?kid=C"; curl -s "$S/token?kid=A"
kill %1
