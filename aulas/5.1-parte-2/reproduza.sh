#!/usr/bin/env bash
# Aula 5.1, Parte 2: ID token × access token: quem consome cada um.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/5.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://localhost:6000/callback
destino() { node -p "const j=require('./t.json');['access_token','id_token','refresh_token'].map(function(k){const b=JSON.parse(Buffer.from(j[k].split('.')[1],'base64url'));return k+': aud='+b.aud+' typ='+b.typ}).join('\n')"; }
# 1. O app de receitas, com a API de receitas no aud do access token (só nele)
echo; echo "== 1. O app de receitas, com a API de receitas no aud do access token (só nele)"
C=$($K create clients -r curso -s clientId=app-de-receitas -s publicClient=true -s 'redirectUris=["http://localhost:6000/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -s 'defaultClientScopes=["basic","acr"]' -s 'optionalClientScopes=["profile","email"]' -i)
$K create clients/$C/protocol-mappers/models -r curso -s name=aud-api-de-receitas -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-receitas' -s 'config."access.token.claim"=true' -s 'config."id.token.claim"=false' -s 'config."lightweight.claim"=true'
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
# 2. O login com openid, profile e email
echo; echo "== 2. O login com openid, profile e email"
echo "$O/auth?response_type=code&client_id=app-de-receitas&redirect_uri=$R&scope=openid%20profile%20email&state=abc&nonce=n-curso-123&code_challenge=$CH&code_challenge_method=S256"
# Abra o endereço, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:
echo; echo "== Abra o endereço, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:"
pede_code CODE
curl -s $O/token -d grant_type=authorization_code -d client_id=app-de-receitas -d redirect_uri=$R -d code_verifier=$V -d code=$CODE -o t.json
# 3. O destino (aud) e o tipo de cada token: a API, o app e o próprio servidor
echo; echo "== 3. O destino (aud) e o tipo de cada token: a API, o app e o próprio servidor"
destino
# 4. O userinfo com cada token: 200 só com o access token
echo; echo "== 4. O userinfo com cada token: 200 só com o access token"
for k in access_token id_token refresh_token; do echo "$k: $(curl -s -o /dev/null -w '%{http_code}' $O/userinfo -H "Authorization: Bearer $(node -p "require('./t.json').$k")")"; done
# 5. As claims do access token
echo; echo "== 5. As claims do access token"
node -p "Object.keys(JSON.parse(Buffer.from(require('./t.json').access_token.split('.')[1],'base64url'))).join(' ')"
# 6. O access token enxuto: ligue a opção abaixo, refaça o passo 2 (do echo ao curl) e repita a linha do passo 5. Saem name, email e sub.
echo; echo "== 6. O access token enxuto: ligue a opção abaixo, refaça o passo 2 (do echo ao curl) e repita a linha do passo 5. Saem name, email e sub."
$K update clients/$C -r curso -s 'attributes."client.use.lightweight.access.token.enabled"=true'
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso; rm -f t.json
