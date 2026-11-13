#!/usr/bin/env bash
# Aula 3.3, Parte 2: Refresh token, expiração e rotação.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.3-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
pkce
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"
url() { echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=$1&state=abc123&code_challenge=$CH&code_challenge_method=S256"; }
troca() { curl -s -o t.json $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$1; node -e "const j=JSON.parse(require('fs').readFileSync('t.json','utf8'));console.log('expires_in:',j.expires_in,'| refresh_expires_in:',j.refresh_expires_in)"; }
campo() { node -p "JSON.parse(require('fs').readFileSync('$1','utf8')).$2"; }
refresh() { curl -s -o $2 -w "%{http_code} " $A/token -d grant_type=refresh_token -d client_id=app-de-fotos -d refresh_token=$1; node -e "const j=JSON.parse(require('fs').readFileSync('$2','utf8'));console.log(j.error ? j.error+' · '+j.error_description : 'par novo · refresh_expires_in: '+j.refresh_expires_in)"; }
# Um login: os dois prazos; o refresh token por dentro (alg e typ)
echo; echo "== Um login: os dois prazos; o refresh token por dentro (alg e typ)"
url openid
pede_code CODE1
troca $CODE1
node -e "const t=JSON.parse(require('fs').readFileSync('t.json','utf8')).refresh_token.split('.');console.log(JSON.parse(Buffer.from(t[0],'base64url')).alg, JSON.parse(Buffer.from(t[1],'base64url')).typ)"
# Sem rotação: o refresh 5 s depois (prazo cheio) e o MESMO refresh token de novo, que também passa
echo; echo "== Sem rotação: o refresh 5 s depois (prazo cheio) e o MESMO refresh token de novo, que também passa"
R1=$(campo t.json refresh_token); sleep 5
refresh $R1 r1.json
refresh $R1 r2.json
# Rotação ligada por um momento: o velho é recusado, e o reuso derruba o login do app
echo; echo "== Rotação ligada por um momento: o velho é recusado, e o reuso derruba o login do app"
$K update realms/curso -s revokeRefreshToken=true -s refreshTokenMaxReuse=0
url openid
pede_code CODE2
troca $CODE2
R1=$(campo t.json refresh_token)
refresh $R1 r1.json
R2=$(campo r1.json refresh_token); T2=$(campo r1.json access_token)
refresh $R1 r2.json
refresh $R2 r3.json
curl -s -o /dev/null -D - $A/userinfo -H "Authorization: Bearer $T2" | grep -i www-authenticate
$K update realms/curso -s revokeRefreshToken=false
# Vida curta: access token de 10 s; userinfo antes e depois; o refresh traz outro
echo; echo "== Vida curta: access token de 10 s; userinfo antes e depois; o refresh traz outro"
C=$($K get clients -r curso -q clientId=app-de-fotos --fields id --format csv --noquotes); $K update clients/$C -r curso -s 'attributes."access.token.lifespan"=10'
url openid
pede_code CODE3
troca $CODE3
T=$(campo t.json access_token)
curl -s -o /dev/null -w "%{http_code}\n" $A/userinfo -H "Authorization: Bearer $T"
sleep 12; curl -s -o /dev/null -D - $A/userinfo -H "Authorization: Bearer $T" | grep -i www-authenticate
refresh $(campo t.json refresh_token) r1.json
# Desfaz
echo; echo "== Desfaz"
$K update clients/$C -r curso -s 'attributes."access.token.lifespan"=300'
