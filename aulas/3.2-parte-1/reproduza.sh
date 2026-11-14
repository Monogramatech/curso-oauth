#!/usr/bin/env bash
# Aula 3.2, Parte 1: Cabeçalho, payload, assinatura e as claims padrão.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"
# Os dois tokens: cabeçalho igual; o ID token traz aud com o app
echo; echo "== Os dois tokens: cabeçalho igual; o ID token traz aud com o app"
node -e "const p=process.argv[1].split('.');console.log(JSON.parse(Buffer.from(p[0],'base64url')),JSON.parse(Buffer.from(p[1],'base64url')))" "$T"
node -e "const p=process.argv[1].split('.');console.log(JSON.parse(Buffer.from(p[0],'base64url')),JSON.parse(Buffer.from(p[1],'base64url')))" "$I"
# O programa da Aula 3.1, parte 1 aceita o ID token
echo; echo "== O programa da Aula 3.1, parte 1 aceita o ID token"
curl -s $A/certs -o jwks.json
node -e "const c=require('crypto'),j=JSON.parse(require('fs').readFileSync('jwks.json','utf8')),p=process.argv[1].split('.'),h=JSON.parse(Buffer.from(p[0],'base64url')),b=JSON.parse(Buffer.from(p[1],'base64url')),k=j.keys.find(function(x){return x.kid===h.kid}),s=b.exp-Math.floor(Date.now()/1000),a=c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url')),i=b.iss===process.argv[2],e=Math.sign(s)===1;console.log('assinatura:',a,'| iss:',i,'| exp: faltam',s,'s | aceito:',a&&i&&e)" "$I" http://localhost:8080/realms/curso
# O perfil da RFC 9068 no app: typ at+jwt e um mapeador de audiência
echo; echo "== O perfil da RFC 9068 no app: typ at+jwt e um mapeador de audiência"
C=$($K get clients -r curso -q clientId=app-de-fotos --fields id --format csv --noquotes)
$K update clients/$C -r curso -s 'attributes."access.token.header.type.rfc9068"=true'
$K create clients/$C/protocol-mappers/models -r curso -s name=aud-api -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-fotos' -s 'config."access.token.claim"=true'
# Login novo (V e CH do passo 3): typ at+jwt e aud api-de-fotos
echo; echo "== Login novo (V e CH do passo 3): typ at+jwt e aud api-de-fotos"
echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=openid%20fotos:publicar&state=abc123&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE3
T3=$(curl -s $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE3 | node -e "console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).access_token)")
node -e "const p=process.argv[1].split('.');console.log(JSON.parse(Buffer.from(p[0],'base64url')),JSON.parse(Buffer.from(p[1],'base64url')))" "$T3"
# Desfaz: a opção volta a false e o mapeador sai
echo; echo "== Desfaz: a opção volta a false e o mapeador sai"
$K update clients/$C -r curso -s 'attributes."access.token.header.type.rfc9068"=false'
M=$($K get clients/$C/protocol-mappers/models -r curso --fields id,name --format csv --noquotes | grep aud-api | cut -d, -f1)
$K delete clients/$C/protocol-mappers/models/$M -r curso
