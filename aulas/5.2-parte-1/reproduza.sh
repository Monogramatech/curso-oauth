#!/usr/bin/env bash
# Aula 5.2, Parte 1: As duas sessões e o logout pedido pelo app (RP-Initiated Logout).
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/5.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://localhost:6000/callback; S=http://localhost:6000/saiu
# 1. O app de receitas, com um endereço de volta depois do logout
echo; echo "== 1. O app de receitas, com um endereço de volta depois do logout"
C=$($K create clients -r curso -s clientId=app-de-receitas -s publicClient=true -s 'redirectUris=["http://localhost:6000/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -s 'attributes."post.logout.redirect.uris"=http://localhost:6000/saiu' -i)
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
# 2. O login
echo; echo "== 2. O login"
echo "$O/auth?response_type=code&client_id=app-de-receitas&redirect_uri=$R&scope=openid&state=abc&code_challenge=$CH&code_challenge_method=S256"
# Abra o endereço, entre com voce / teste123. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:
echo; echo "== Abra o endereço, entre com voce / teste123. A página de retorno não abre, mas a barra traz o code. Em menos de 1 minuto:"
pede_code CODE
curl -s $O/token -d grant_type=authorization_code -d client_id=app-de-receitas -d redirect_uri=$R -d code_verifier=$V -d code=$CODE -o t.json
# 3. Sair só do app: abra de novo o endereço do passo 2, no mesmo navegador. O servidor não pede a senha.
echo; echo "== 3. Sair só do app: abra de novo o endereço do passo 2, no mesmo navegador. O servidor não pede a senha."
# 4. O endereço de logout, na descoberta
echo; echo "== 4. O endereço de logout, na descoberta"
curl -s http://localhost:8080/realms/curso/.well-known/openid-configuration | node -p "JSON.parse(require('fs').readFileSync(0)).end_session_endpoint"
# 5. Sem a dica, o servidor pergunta e não encerra nada (aqui, sem o cookie da sessão, só com o client_id)
echo; echo "== 5. Sem a dica, o servidor pergunta e não encerra nada (aqui, sem o cookie da sessão, só com o client_id)"
curl -s "$O/logout?client_id=app-de-receitas" | grep -o "Do you want to log out?"
# 6. Com a dica e o state: 302, de volta para o app, com o mesmo state
echo; echo "== 6. Com a dica e o state: 302, de volta para o app, com o mesmo state"
curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" "$O/logout?id_token_hint=$(node -p "require('./t.json').id_token")&post_logout_redirect_uri=$S&state=s-1"
# 7. Depois do logout: o refresh token antigo é recusado (Session not active)
echo; echo "== 7. Depois do logout: o refresh token antigo é recusado (Session not active)"
curl -s $O/token -d grant_type=refresh_token -d client_id=app-de-receitas -d refresh_token=$(node -p "require('./t.json').refresh_token"); echo
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso; rm -f t.json
