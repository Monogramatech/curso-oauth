#!/usr/bin/env bash
# Aula 7.3, Parte 2: PAR e RAR: pedidos de autorização seguros e detalhados.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/7.3-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. Os metadados publicam o endpoint do PAR
echo; echo "== 1. Os metadados publicam o endpoint do PAR"
curl -s $I/.well-known/openid-configuration | grep -o '"pushed_authorization_request_endpoint":"[^"]*"'
# 2. Um client confidencial que só aceita o pedido de autorização pelo PAR
echo; echo "== 2. Um client confidencial que só aceita o pedido de autorização pelo PAR"
C=$($K create clients -r curso -s clientId=fotos-par -s publicClient=false -s 'redirectUris=["http://localhost:3000/callback"]' -s 'attributes."require.pushed.authorization.requests"=true' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
# 3. O PAR: o pedido vai no corpo de um POST autenticado; volta 201, com a referência (request_uri) e o prazo
echo; echo "== 3. O PAR: o pedido vai no corpo de um POST autenticado; volta 201, com a referência (request_uri) e o prazo"
curl -s -u fotos-par:$S $I/protocol/openid-connect/ext/par/request -d response_type=code -d client_id=fotos-par -d redirect_uri=http://localhost:3000/callback -d scope=openid -d code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM -d code_challenge_method=S256 -w ' (status %{http_code})\n'
# 4. O pedido clássico, com tudo no endereço: o Keycloak devolve no redirect com erro
echo; echo "== 4. O pedido clássico, com tudo no endereço: o Keycloak devolve no redirect com erro"
curl -s -o /dev/null -w '%{redirect_url}\n' "$I/protocol/openid-connect/auth?response_type=code&client_id=fotos-par&redirect_uri=http://localhost:3000/callback&scope=openid"
# 5. Com o segredo errado, o PAR cai antes de qualquer tela
echo; echo "== 5. Com o segredo errado, o PAR cai antes de qualquer tela"
curl -s -u fotos-par:errado $I/protocol/openid-connect/ext/par/request -d response_type=code -d client_id=fotos-par -d redirect_uri=http://localhost:3000/callback -d scope=openid -w ' (status %{http_code})\n'
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
