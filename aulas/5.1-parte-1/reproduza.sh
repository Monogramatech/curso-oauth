#!/usr/bin/env bash
# Aula 5.1, Parte 1: O que o OIDC acrescenta: escopo openid, ID token, UserInfo.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/5.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://localhost:6000/callback
corpo() { node -p "JSON.parse(Buffer.from(require('fs').readFileSync(0,'utf8').split('.')[1],'base64url'))"; }
# 1. O app de receitas: público, com PKCE; profile e email só vêm se o app pedir
echo; echo "== 1. O app de receitas: público, com PKCE; profile e email só vêm se o app pedir"
C=$($K create clients -r curso -s clientId=app-de-receitas -s publicClient=true -s consentRequired=true -s 'redirectUris=["http://localhost:6000/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -s 'defaultClientScopes=["basic","acr"]' -s 'optionalClientScopes=["profile","email"]' -i)
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
# 2. O login com openid, profile e email, e um nonce
echo; echo "== 2. O login com openid, profile e email, e um nonce"
echo "$O/auth?response_type=code&client_id=app-de-receitas&redirect_uri=$R&scope=openid%20profile%20email&state=abc&nonce=n-curso-123&code_challenge=$CH&code_challenge_method=S256"
# Abra o endereço, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:
echo; echo "== Abra o endereço, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:"
pede_code CODE
curl -s $O/token -d grant_type=authorization_code -d client_id=app-de-receitas -d redirect_uri=$R -d code_verifier=$V -d code=$CODE | tee t.json; echo
# 3. O ID token por dentro: aud é o app, o nonce voltou, auth_time e acr
echo; echo "== 3. O ID token por dentro: aud é o app, o nonce voltou, auth_time e acr"
node -p "require('./t.json').id_token" | corpo
# 4. O userinfo, com o access token
echo; echo "== 4. O userinfo, com o access token"
curl -s $O/userinfo -H "Authorization: Bearer $(node -p "require('./t.json').access_token")"; echo
# 5. Sem openid: refaça o passo 2 com scope=email e troque o code. A resposta vem sem id_token, e o userinfo responde 403.
echo; echo "== 5. Sem openid: refaça o passo 2 com scope=email e troque o code. A resposta vem sem id_token, e o userinfo responde 403."
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso; rm -f t.json
