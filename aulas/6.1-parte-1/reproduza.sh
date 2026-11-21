#!/usr/bin/env bash
# Aula 6.1, Parte 1: Back-end web clássico: sessão por cookie e tokens no servidor.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/6.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://receitas.localhost:6200/callback
# 1. O app de receitas com servidor: cliente confidencial, com PKCE
echo; echo "== 1. O app de receitas com servidor: cliente confidencial, com PKCE"
C=$($K create clients -r curso -s clientId=receitas-web -s 'redirectUris=["http://receitas.localhost:6200/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
# 2. O servidor do app (deixe rodando): um cookie de sessão HttpOnly e um cookie comum
echo; echo "== 2. O servidor do app (deixe rodando): um cookie de sessão HttpOnly e um cookie comum"
node -e "require('http').createServer(function(q,s){s.writeHead(200,{'Set-Cookie':['sessao=abc123; HttpOnly; Secure; SameSite=Lax; Path=/','tema=escuro; Path=/'],'Content-Type':'text/plain'});s.end('app de receitas')}).listen(6200)" &
# 3. O login: abra o endereço e entre com voce / teste123. A volta cai no passo 2, e a barra traz o code. Em menos de 1 minuto:
echo; echo "== 3. O login: abra o endereço e entre com voce / teste123. A volta cai no passo 2, e a barra traz o code. Em menos de 1 minuto:"
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
echo "$O/auth?response_type=code&client_id=receitas-web&redirect_uri=$R&scope=openid&state=abc&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE
# 4. A troca pelo canal de trás, com o segredo do app: os tokens ficam aqui, no servidor, e não no navegador
echo; echo "== 4. A troca pelo canal de trás, com o segredo do app: os tokens ficam aqui, no servidor, e não no navegador"
curl -s $O/token -u receitas-web:$S -d grant_type=authorization_code -d redirect_uri=$R -d code_verifier=$V -d code=$CODE | head -c 120; echo
# 5. No console do navegador (F12), na página do app: document.cookie mostra tema=escuro, mas não a sessao
echo; echo "== 5. No console do navegador (F12), na página do app: document.cookie mostra tema=escuro, mas não a sessao"
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso
