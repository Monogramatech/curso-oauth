#!/usr/bin/env bash
# Aula 8.2, Parte 1: O checklist de segurança do OAuth em 2026.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/8.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. Um client público como muitos ainda estão: asterisco no endereço e a senha direta ligada
echo; echo "== 1. Um client público como muitos ainda estão: asterisco no endereço e a senha direta ligada"
C=$($K create clients -r curso -s clientId=revisao-teste -s publicClient=true -s 'redirectUris=["http://localhost:3000/*"]' -s directAccessGrantsEnabled=true -i)
# 2. Os campos que a lista confere (endereço, implícito, senha direta, PKCE, DPoP)
echo; echo "== 2. Os campos que a lista confere (endereço, implícito, senha direta, PKCE, DPoP)"
$K get clients/$C -r curso --fields redirectUris,implicitFlowEnabled,directAccessGrantsEnabled,attributes; echo
# 3. A senha direta aberta: com uma senha inventada, o Keycloak confere a credencial (401); o grant está liberado
echo; echo "== 3. A senha direta aberta: com uma senha inventada, o Keycloak confere a credencial (401); o grant está liberado"
curl -s $I/token -d grant_type=password -d client_id=revisao-teste -d username=voce -d password=inventada -w ' (status %{http_code})\n'
# 4. A correção: senha direta desligada e PKCE S256 exigido
echo; echo "== 4. A correção: senha direta desligada e PKCE S256 exigido"
$K update clients/$C -r curso -s directAccessGrantsEnabled=false -s 'attributes."pkce.code.challenge.method"=S256'
curl -s $I/token -d grant_type=password -d client_id=revisao-teste -d username=voce -d password=inventada -w ' (status %{http_code})\n'
curl -s -o /dev/null -w '%{redirect_url}\n' "$I/auth?response_type=code&client_id=revisao-teste&scope=openid&redirect_uri=http://localhost:3000/callback"
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
