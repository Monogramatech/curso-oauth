#!/usr/bin/env bash
# Aula 7.1, Parte 1: Validar token em toda requisição: middleware, cache de JWKS, erros 401 e 403.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/7.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. Um client de serviço (sem navegador): token at+jwt (RFC 9068) com a API no aud
echo; echo "== 1. Um client de serviço (sem navegador): token at+jwt (RFC 9068) com a API no aud"
C=$($K create clients -r curso -s clientId=job-de-fotos -s serviceAccountsEnabled=true -s 'optionalClientScopes=["fotos:publicar"]' -s 'attributes."access.token.header.type.rfc9068"=true' -s 'protocolMappers=[{"name":"aud","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.custom.audience":"http://localhost:4000","access.token.claim":"true"}}]' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
tk() { curl -s $I/protocol/openid-connect/token -u job-de-fotos:$S -d grant_type=client_credentials -d scope=$1 | sed 's/.*"access_token":"//;s/".*//'; }
# 2. A API (deixe rodando). Kid desconhecido: busca o JWKS de novo, no máximo a cada 10 s
echo; echo "== 2. A API (deixe rodando). Kid desconhecido: busca o JWKS de novo, no máximo a cada 10 s"
I=$I node -e "require('dns').setDefaultResultOrder('ipv4first');var c=require('crypto'),E=process.env,K=[],B=0,R='http://localhost:4000',d=function(s){return JSON.parse(Buffer.from(s,'base64url'))};async function chave(id){var k=K.find(function(x){return x.kid==id});if(k==null&&Math.sign(Date.now()-B-1e4)==1){B=Date.now();K=(await(await fetch(E.I+'/protocol/openid-connect/certs')).json()).keys;console.log('API: busquei o JWKS');k=K.find(function(x){return x.kid==id})}return k}require('http').createServer(async function(q,r){var m=/^Bearer (\S+)$/i.exec(q.headers.authorization||''),f=function(s,a){r.writeHead(s,{'www-authenticate':'Bearer'+a});r.end()};if(m==null)return f(401,'');var p=m[1].split('.'),h=d(p[0]),b=d(p[1]),k=await chave(h.kid);if(k&&c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url'))&&h.typ=='at+jwt'&&b.iss==E.I&&[].concat(b.aud).includes(R)&&Math.sign(b.exp-Date.now()/1000)==1){if(q.method=='POST'&&b.scope.split(' ').includes('fotos:publicar')==false)return f(403,' error=\"insufficient_scope\", scope=\"fotos:publicar\"');r.writeHead(q.method=='POST'?201:200);return r.end()}f(401,' error=\"invalid_token\"')}).listen(4000,'127.0.0.1')" &
sleep 2; A=127.0.0.1:4000/fotos; v() { curl -si "$@" | grep -iE '^HTTP|www-auth'; }
# 3. Sem token: 401. Sem o escopo: ver passa, publicar leva 403. Com o escopo: 201
echo; echo "== 3. Sem token: 401. Sem o escopo: ver passa, publicar leva 403. Com o escopo: 201"
v $A; T=$(tk openid); v $A -H "Authorization: Bearer $T"; v -X POST $A -H "Authorization: Bearer $T"; v -X POST $A -H "Authorization: Bearer $(tk fotos:publicar)"
# 4. Troca de chave: o token novo traz outro kid, e a API busca o JWKS
echo; echo "== 4. Troca de chave: o token novo traz outro kid, e a API busca o JWKS"
G=$($K create components -r curso -s name=chave-nova -s providerId=rsa-generated -s providerType=org.keycloak.keys.KeyProvider -s 'config.priority=["200"]' -i)
sleep 11; v $A -H "Authorization: Bearer $(tk openid)"
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete components/$G -r curso; $K delete clients/$C -r curso
