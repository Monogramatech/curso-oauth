#!/usr/bin/env bash
# Aula 7.1, Parte 2: Escopo, papel e claim: do token à decisão de acesso.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/7.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. Um client de serviço e o perfil publicador
echo; echo "== 1. Um client de serviço e o perfil publicador"
C=$($K create clients -r curso -s clientId=job-de-fotos -s serviceAccountsEnabled=true -s 'defaultClientScopes=["basic","roles"]' -s 'optionalClientScopes=["fotos:publicar"]' -s 'protocolMappers=[{"name":"aud","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.custom.audience":"http://localhost:4000","access.token.claim":"true"}}]' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
D=$($K get clients/$C/service-account-user -r curso --fields id --format csv --noquotes)
$K create roles -r curso -s name=publicador
tk() { curl -s $I/protocol/openid-connect/token -u job-de-fotos:$S -d grant_type=client_credentials -d scope=$1 | sed 's/.*"access_token":"//;s/".*//'; }
# 2. A API (deixe rodando): a foto 1 é do client; a 2, de outra pessoa
echo; echo "== 2. A API (deixe rodando): a foto 1 é do client; a 2, de outra pessoa"
I=$I D=$D node -e "require('dns').setDefaultResultOrder('ipv4first');var c=require('crypto'),E=process.env,K=null,d=function(s){return JSON.parse(Buffer.from(s,'base64url'))},F={1:E.D,2:'outra-pessoa'};async function chave(id){K=K||(await(await fetch(E.I+'/protocol/openid-connect/certs')).json()).keys;return K.find(function(x){return x.kid==id})}require('http').createServer(async function(q,r){var f=function(s,o,a){r.writeHead(s,a==null?{}:{'www-authenticate':'Bearer'+a});r.end(o?JSON.stringify(o):'')},m=/^Bearer (\S+)$/i.exec(q.headers.authorization||'');if(m==null)return f(401,null,'');var p=m[1].split('.'),h=d(p[0]),b=d(p[1]),k=await chave(h.kid);if(Boolean(k&&c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url'))&&b.iss==E.I&&[].concat(b.aud).includes('http://localhost:4000')&&Math.sign(b.exp-Date.now()/1000)==1)==false)return f(401,null,' error=\"invalid_token\"');var g=/^\/fotos\/(\d+)$/.exec(q.url);if(g)return g&&F[g[1]]==b.sub?f(200,{foto:g[1]}):f(404,{erro:'foto nao encontrada'});if(b.scope.split(' ').includes('fotos:publicar')==false)return f(403,null,' error=\"insufficient_scope\", scope=\"fotos:publicar\"');if(((b.realm_access||{}).roles||[]).includes('publicador')==false)return f(403,{erro:'falta o perfil publicador'});f(201,{publicada:true})}).listen(4000,'127.0.0.1')" &
sleep 2; A=127.0.0.1:4000; v() { curl -si -H "Authorization: Bearer $1" "${@:2}" | grep -E 'HTTP/|"'; }
# 3. O dono: a foto 1 sai; a 2 (de outra pessoa) e a 99 (não existe), o mesmo 404
echo; echo "== 3. O dono: a foto 1 sai; a 2 (de outra pessoa) e a 99 (não existe), o mesmo 404"
T=$(tk openid); for n in 1 2 99; do v $T $A/fotos/$n; done
# 4. Sem o escopo: 403 com desafio. Sem o perfil: 403 sem desafio. Com os dois: 201
echo; echo "== 4. Sem o escopo: 403 com desafio. Sem o perfil: 403 sem desafio. Com os dois: 201"
v $T -X POST $A/fotos; v $(tk fotos:publicar) -X POST $A/fotos
$K add-roles -r curso --uusername service-account-job-de-fotos --rolename publicador; v $(tk fotos:publicar) -X POST $A/fotos
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso; $K delete roles/publicador -r curso
