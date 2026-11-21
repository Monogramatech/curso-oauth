#!/usr/bin/env bash
# Aula 7.2, Parte 1: Validar na borda, validar em cada serviço, ou os dois.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/7.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. Um client de serviço; o token sai com o aud do serviço de fotos
echo; echo "== 1. Um client de serviço; o token sai com o aud do serviço de fotos"
C=$($K create clients -r curso -s clientId=job-de-fotos -s serviceAccountsEnabled=true -s 'protocolMappers=[{"name":"aud-fotos","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.custom.audience":"http://localhost:4000/fotos","access.token.claim":"true"}}]' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
tk() { curl -s $I/protocol/openid-connect/token -u job-de-fotos:$S -d grant_type=client_credentials | sed 's/.*"access_token":"//;s/".*//'; }
# 2. Dois serviços (deixe rodando): cada um confere o token e o próprio aud
echo; echo "== 2. Dois serviços (deixe rodando): cada um confere o token e o próprio aud"
sv() { I=$I A=http://localhost:4000/$1 node -e "require('dns').setDefaultResultOrder('ipv4first');var c=require('crypto'),E=process.env,K=null,d=function(s){return JSON.parse(Buffer.from(s,'base64url'))};require('http').createServer(async function(q,r){var f=function(s,e){r.writeHead(s,e?{'www-authenticate':'Bearer error=\"invalid_token\", error_description=\"'+e+'\"'}:{});r.end(e?'':E.A)},m=/^Bearer (\S+)$/i.exec(q.headers.authorization||'');if(m==null)return f(401,'sem token');var p=m[1].split('.'),h=d(p[0]),b=d(p[1]);K=K||(await(await fetch(E.I+'/protocol/openid-connect/certs')).json()).keys;var k=K.find(function(x){return x.kid==h.kid});if(Boolean(k&&c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url'))&&b.iss==E.I&&Math.sign(b.exp-Date.now()/1000)==1)==false)return f(401,'token invalido');if([].concat(b.aud).includes(E.A)==false)return f(401,'token de outra API');f(200)}).listen(process.argv[1],'127.0.0.1')" $2 & }
sv fotos 4101; sv pagamentos 4102; sleep 2; v() { curl -si -H "Authorization: Bearer $1" $2 | grep -E 'HTTP/|www-|localhost'; }
# 3. O token de fotos: o serviço de fotos aceita; o de pagamentos recusa (token de outra API)
echo; echo "== 3. O token de fotos: o serviço de fotos aceita; o de pagamentos recusa (token de outra API)"
T=$(tk); v $T 127.0.0.1:4101/; v $T 127.0.0.1:4102/
# 4. Com as duas audiências no token, os dois aceitam: quem tem o token entra nos dois
echo; echo "== 4. Com as duas audiências no token, os dois aceitam: quem tem o token entra nos dois"
$K create clients/$C/protocol-mappers/models -r curso -s name=aud-pagamentos -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=http://localhost:4000/pagamentos' -s 'config."access.token.claim"=true'
T=$(tk); v $T 127.0.0.1:4101/; v $T 127.0.0.1:4102/
# Desfaz
echo; echo "== Desfaz"
kill %1 %2; $K delete clients/$C -r curso
