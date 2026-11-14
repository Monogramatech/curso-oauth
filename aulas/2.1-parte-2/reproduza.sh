#!/usr/bin/env bash
# Aula 2.1, Parte 2: /authorize, /token e o canal da frente × o canal de trás.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/2.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
# Metadados da RFC 8414: o caminho padrão entra entre o host e o caminho do issuer.
echo; echo "== Metadados da RFC 8414: o caminho padrão entra entre o host e o caminho do issuer."
unalias -a
curl -s http://localhost:8080/.well-known/oauth-authorization-server/realms/curso | node -e "const m=JSON.parse(require('fs').readFileSync(0,'utf8'));console.log(m.issuer,m.authorization_endpoint,m.token_endpoint,m.code_challenge_methods_supported)"
# Canal da frente: o pedido vai no endereço. Abra o endereço impresso, entre com voce / teste123 e permita.
echo; echo "== Canal da frente: o pedido vai no endereço. Abra o endereço impresso, entre com voce / teste123 e permita."
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64)
CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
echo "http://localhost:8080/realms/curso/protocol/openid-connect/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=openid&state=abc123&code_challenge=$CH&code_challenge_method=S256"
# A resposta volta pelo endereço: a página não abre, mas a barra traz o code e o state. Em menos de 1 minuto:
echo; echo "== A resposta volta pelo endereço: a página não abre, mas a barra traz o code e o state. Em menos de 1 minuto:"
pede_code CODE
T=http://localhost:8080/realms/curso/protocol/openid-connect/token
F="-d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback"
# Canal de trás: POST direto, com o code e o verifier no corpo. O -i mostra Cache-Control: no-store.
echo; echo "== Canal de trás: POST direto, com o code e o verifier no corpo. O -i mostra Cache-Control: no-store."
curl -si $T $F -d code_verifier=$V -d code=$CODE
# O mesmo code de novo: 400, invalid_grant.
echo; echo "== O mesmo code de novo: 400, invalid_grant."
curl -si $T $F -d code_verifier=$V -d code=$CODE
# Sem o verifier: abra o endereço de novo (ele volta direto), copie o code novo e troque sem o code_verifier.
echo; echo "== Sem o verifier: abra o endereço de novo (ele volta direto), copie o code novo e troque sem o code_verifier."
pede_code CODE2
curl -si $T $F -d code=$CODE2
