#!/usr/bin/env bash
# Aula 3.1, Parte 1: Token opaco × JWT, e o token de portador (Bearer).
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
unalias -a
A="http://localhost:8080/realms/curso/protocol/openid-connect"
# O token em outro programa: só o cabeçalho, e a API responde
echo; echo "== O token em outro programa: só o cabeçalho, e a API responde"
curl -s $A/userinfo -H "Authorization: Bearer $T"
# Recusas e WWW-Authenticate: sem token, token alterado, na URL (ignorado); no corpo, aceito
echo; echo "== Recusas e WWW-Authenticate: sem token, token alterado, na URL (ignorado); no corpo, aceito"
curl -si $A/userinfo | grep -i -e "^HTTP" -e www-auth
curl -si $A/userinfo -H "Authorization: Bearer ${T%???}AAA" | grep -i -e "^HTTP" -e www-auth
curl -si "$A/userinfo?access_token=$T" | grep -i -e "^HTTP" -e www-auth
curl -s $A/userinfo -d access_token=$T
# Token sem openid: entre por este endereço e troque o code (V e CH do passo 3)
echo; echo "== Token sem openid: entre por este endereço e troque o code (V e CH do passo 3)"
echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=fotos:publicar&state=abc123&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE2
T2=$(curl -s $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE2 | node -e "console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).access_token)")
curl -si $A/userinfo -H "Authorization: Bearer $T2" | grep -i -e "^HTTP" -e www-auth
# O corpo do JWT: qualquer um lê, até o nome e o e-mail
echo; echo "== O corpo do JWT: qualquer um lê, até o nome e o e-mail"
node -e "console.log(JSON.parse(Buffer.from(process.argv[1].split('.')[1],'base64url')))" "$T2"
# Servidor pausado: guarde o JWKS, pause o Keycloak e confira o token sem ele
echo; echo "== Servidor pausado: guarde o JWKS, pause o Keycloak e confira o token sem ele"
curl -s $A/certs -o jwks.json
docker pause kc
curl -s -m 5 $A/certs; echo "curl saiu com $? (28: sem resposta)"
curl -s -m 5 $A/userinfo -H "Authorization: Bearer $T"; echo "userinfo: $? (parou junto)"
node -e "const c=require('crypto'),j=JSON.parse(require('fs').readFileSync('jwks.json','utf8')),p=process.argv[1].split('.'),h=JSON.parse(Buffer.from(p[0],'base64url')),b=JSON.parse(Buffer.from(p[1],'base64url')),k=j.keys.find(function(x){return x.kid===h.kid}),s=b.exp-Math.floor(Date.now()/1000),a=c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url')),i=b.iss===process.argv[2],e=Math.sign(s)===1;console.log('assinatura:',a,'| iss:',i,'| exp: faltam',s,'s | aceito:',a&&i&&e)" "$T2" http://localhost:8080/realms/curso
docker unpause kc
# Valor opaco: 32 bytes aleatórios; o userinfo recusa
echo; echo "== Valor opaco: 32 bytes aleatórios; o userinfo recusa"
O=$(node -e "console.log(require('crypto').randomBytes(32).toString('base64url'))"); echo "$O ${#O}"
curl -si $A/userinfo -H "Authorization: Bearer $O" | grep -i www-auth
