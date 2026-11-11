#!/usr/bin/env bash
# Aula 3.1, Parte 2: Introspecção e revogação.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
K="docker exec kc /opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"
# A API ganha um client confidencial, só para perguntar ao servidor (segredo de teste)
echo; echo "== A API ganha um client confidencial, só para perguntar ao servidor (segredo de teste)"
$K create clients -r curso -s clientId=api-de-fotos -s publicClient=false -s standardFlowEnabled=false -s directAccessGrantsEnabled=false -s secret=segredo-da-api
# Introspecção: com as credenciais da API; sem credencial (401); pelo app público (403); um valor qualquer
echo; echo "== Introspecção: com as credenciais da API; sem credencial (401); pelo app público (403); um valor qualquer"
curl -s $A/token/introspect -u api-de-fotos:segredo-da-api -d token=$T
curl -s $A/token/introspect -d token=$T
curl -s $A/token/introspect -d client_id=app-de-fotos -d token=$T
curl -s $A/token/introspect -u api-de-fotos:segredo-da-api -d token=qualquer-valor
# O app revoga o access token: o servidor diz active false, mas a API que confere sozinha ainda aceita
echo; echo "== O app revoga o access token: o servidor diz active false, mas a API que confere sozinha ainda aceita"
curl -s $A/certs -o jwks.json
curl -si $A/revoke -d client_id=app-de-fotos -d token_type_hint=access_token -d token=$T | head -1
curl -s $A/token/introspect -u api-de-fotos:segredo-da-api -d token=$T
curl -si $A/revoke -d client_id=app-de-fotos -d token=valor-que-nao-existe | head -1
node -e "const c=require('crypto'),j=JSON.parse(require('fs').readFileSync('jwks.json','utf8')),p=process.argv[1].split('.'),h=JSON.parse(Buffer.from(p[0],'base64url')),b=JSON.parse(Buffer.from(p[1],'base64url')),k=j.keys.find(function(x){return x.kid===h.kid}),s=b.exp-Math.floor(Date.now()/1000),a=c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url')),i=b.iss===process.argv[2],e=Math.sign(s)===1;console.log('assinatura:',a,'| iss:',i,'| exp: faltam',s,'s | aceito:',a&&i&&e)" "$T" http://localhost:8080/realms/curso
# O refresh token ainda dá um access token novo. Depois, o app revoga o refresh token, e a sessão acaba
echo; echo "== O refresh token ainda dá um access token novo. Depois, o app revoga o refresh token, e a sessão acaba"
N=$(curl -s $A/token -d grant_type=refresh_token -d client_id=app-de-fotos -d refresh_token=$R | node -e "console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).access_token)")
curl -s $A/token/introspect -u api-de-fotos:segredo-da-api -d token=$N | grep -o '"active":[a-z]*'
curl -si $A/revoke -d client_id=app-de-fotos -d token_type_hint=refresh_token -d token=$R | head -1
curl -s $A/token -d grant_type=refresh_token -d client_id=app-de-fotos -d refresh_token=$R
curl -s $A/token/introspect -u api-de-fotos:segredo-da-api -d token=$N
