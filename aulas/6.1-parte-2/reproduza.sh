#!/usr/bin/env bash
# Aula 6.1, Parte 2: SPA: onde guardar o token e por que não no localStorage.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/6.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://spa.localhost:6300/
# 1. Cliente público (sem segredo), com PKCE e a origem do app registrada
echo; echo "== 1. Cliente público (sem segredo), com PKCE e a origem do app registrada"
C=$($K create clients -r curso -s clientId=receitas-spa -s publicClient=true -s 'redirectUris=["http://spa.localhost:6300/"]' -s 'webOrigins=["http://spa.localhost:6300"]' -s 'attributes."pkce.code.challenge.method"=S256' -i)
# 2. A página do app (deixe rodando)
echo; echo "== 2. A página do app (deixe rodando)"
node -e "require('http').createServer(function(q,s){s.end('app de receitas (SPA): abra o console (F12)')}).listen(6300)" &
# 3. CORS: o Keycloak deixa a origem do app ler a resposta do /token
echo; echo "== 3. CORS: o Keycloak deixa a origem do app ler a resposta do /token"
curl -si $O/token -H "Origin: http://spa.localhost:6300" -d client_id=receitas-spa -d grant_type=refresh_token -d refresh_token=x | grep -i allow-origin
# 4. Abra o 1º endereço e entre com voce / teste123. Na página do app, cole a 2ª linha no console (F12), em menos de 1 minuto
echo; echo "== 4. Abra o 1º endereço e entre com voce / teste123. Na página do app, cole a 2ª linha no console (F12), em menos de 1 minuto"
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
A="$O/auth?response_type=code&client_id=receitas-spa&redirect_uri=$R&scope=openid&code_challenge=$CH&code_challenge_method=S256"; echo "$A"
echo "fetch('$O/token',{method:'POST',body:new URLSearchParams({grant_type:'authorization_code',client_id:'receitas-spa',redirect_uri:'$R',code_verifier:'$V',code:new URLSearchParams(location.search).get('code')})}).then(function(r){return r.json()}).then(function(t){localStorage.setItem('tokens',JSON.stringify(t))})"
# 5. No console, qualquer script da página lê os tokens; recarregue (F5), e eles continuam lá. Copie o refresh token:
echo; echo "== 5. No console, qualquer script da página lê os tokens; recarregue (F5), e eles continuam lá. Copie o refresh token:"
#    copy(JSON.parse(localStorage.getItem('tokens')).refresh_token)
echo; echo "==    copy(JSON.parse(localStorage.getItem('tokens')).refresh_token)"
RT=cole_o_refresh_token_aqui
# 6. Fora do navegador, sem cookie, ele renova
echo; echo "== 6. Fora do navegador, sem cookie, ele renova"
curl -s $O/token -d grant_type=refresh_token -d client_id=receitas-spa -d refresh_token=$RT | head -c 60; echo
# 7. Com a sessão do Keycloak aberta, este endereço volta ao app com um code novo, sem senha
echo; echo "== 7. Com a sessão do Keycloak aberta, este endereço volta ao app com um code novo, sem senha"
echo "$A&prompt=none"
# 8. Saia do Keycloak (abra e confirme). Depois, o mesmo refresh token dá Session not active
echo; echo "== 8. Saia do Keycloak (abra e confirme). Depois, o mesmo refresh token dá Session not active"
echo "$O/logout?client_id=receitas-spa"
curl -s $O/token -d grant_type=refresh_token -d client_id=receitas-spa -d refresh_token=$RT; echo
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso
