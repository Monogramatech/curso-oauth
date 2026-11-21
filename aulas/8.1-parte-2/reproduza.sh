#!/usr/bin/env bash
# Aula 8.1, Parte 2: Mix-up, token em log e confused deputy.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/8.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. O Keycloak anuncia que manda o iss na resposta de autorização (RFC 9207)
echo; echo "== 1. O Keycloak anuncia que manda o iss na resposta de autorização (RFC 9207)"
curl -s $I/.well-known/openid-configuration | grep -o '"authorization_response_iss_parameter_supported":[a-z]*'
# 2. Um client público de teste
echo; echo "== 2. Um client público de teste"
C=$($K create clients -r curso -s clientId=agregador-teste -s publicClient=true -s 'redirectUris=["http://localhost:3000/callback"]' -i)
# 3. A volta ao app traz o iss: o emissor de quem respondeu (aqui, num erro de escopo, sem precisar de login)
echo; echo "== 3. A volta ao app traz o iss: o emissor de quem respondeu (aqui, num erro de escopo, sem precisar de login)"
curl -s -o /dev/null -w '%{redirect_url}\n' "$I/protocol/openid-connect/auth?response_type=code&client_id=agregador-teste&scope=inexistente&redirect_uri=http://localhost:3000/callback"
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
