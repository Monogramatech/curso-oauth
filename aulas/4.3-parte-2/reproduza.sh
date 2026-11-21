#!/usr/bin/env bash
# Aula 4.3, Parte 2: Implicit e Password: por que saíram.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.3-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. Um registro novo: os dois fluxos vêm desligados
echo; echo "== 1. Um registro novo: os dois fluxos vêm desligados"
P=$($K create clients -r curso -s clientId=padrao -i); $K get clients/$P -r curso --fields implicitFlowEnabled,directAccessGrantsEnabled; $K delete clients/$P -r curso
# 2. O Implicit: uma SPA antiga, só com o Implicit ligado
echo; echo "== 2. O Implicit: uma SPA antiga, só com o Implicit ligado"
S=$($K create clients -r curso -s clientId=spa-antiga -s publicClient=true -s standardFlowEnabled=false -s implicitFlowEnabled=true -s consentRequired=true -s 'redirectUris=["http://localhost:5000/callback"]' -i)
echo "$O/auth?response_type=token&client_id=spa-antiga&redirect_uri=http://localhost:5000/callback&scope=openid&state=abc&nonce=xyz"
# Abra o endereço no navegador, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra de endereço
echo; echo "== Abra o endereço no navegador, entre com voce / teste123 e permita. A página de retorno não abre, mas a barra de endereço"
# traz o token depois do #: access_token, token_type e expires_in. Nenhum refresh_token.
echo; echo "== traz o token depois do #: access_token, token_type e expires_in. Nenhum refresh_token."
# 3. O Password: o app recebe a senha e pede o token
echo; echo "== 3. O Password: o app recebe a senha e pede o token"
A=$($K create clients -r curso -s clientId=app-com-senha -s publicClient=true -s standardFlowEnabled=false -s directAccessGrantsEnabled=true -i)
curl -s $O/token -d grant_type=password -d client_id=app-com-senha -d username=voce -d password=teste123 -d scope=openid | head -c 160; echo
curl -s $O/token -d grant_type=password -d client_id=app-com-senha -d username=voce -d password=errada; echo
# 4. Com o consentimento obrigatório, o Password para: o servidor não tem tela para perguntar
echo; echo "== 4. Com o consentimento obrigatório, o Password para: o servidor não tem tela para perguntar"
$K update clients/$A -r curso -s consentRequired=true
curl -s $O/token -d grant_type=password -d client_id=app-com-senha -d username=voce -d password=teste123; echo
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$S -r curso; $K delete clients/$A -r curso
