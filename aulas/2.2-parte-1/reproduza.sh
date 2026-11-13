#!/usr/bin/env bash
# Aula 2.2, Parte 1: Cliente público × confidencial, client_id, redirect_uri.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/2.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
# O client confidencial site-de-fotos e o segredo que o Keycloak gera (de teste).
echo; echo "== O client confidencial site-de-fotos e o segredo que o Keycloak gera (de teste)."
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
$K create clients -r curso -s clientId=site-de-fotos -s publicClient=false -s 'redirectUris=["http://localhost:4000/callback"]' -s 'attributes."pkce.code.challenge.method"=S256'
ID=$($K get clients -r curso -q clientId=site-de-fotos --fields id --format csv --noquotes)
SEGREDO=$($K get clients/$ID/client-secret -r curso --fields value --format csv --noquotes)
# Login pelo site-de-fotos: abra o endereço, entre com voce / teste123 e copie o code da barra.
echo; echo "== Login pelo site-de-fotos: abra o endereço, entre com voce / teste123 e copie o code da barra."
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64)
CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
A="http://localhost:8080/realms/curso/protocol/openid-connect"
echo "$A/auth?response_type=code&client_id=site-de-fotos&redirect_uri=http://localhost:4000/callback&scope=openid&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE
F="-d grant_type=authorization_code -d redirect_uri=http://localhost:4000/callback -d code_verifier=$V"
# Sem o segredo: 401. Com o Basic (o -u do curl monta client_id:segredo): 200.
echo; echo "== Sem o segredo: 401. Com o Basic (o -u do curl monta client_id:segredo): 200."
curl -s $A/token $F -d client_id=site-de-fotos -d code=$CODE
curl -s -u "site-de-fotos:$SEGREDO" $A/token $F -d code=$CODE
# Uma barra a mais no endereço de retorno: 400 e nenhum redirecionamento.
echo; echo "== Uma barra a mais no endereço de retorno: 400 e nenhum redirecionamento."
curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback/&scope=openid&code_challenge=$CH&code_challenge_method=S256"
# Registro dinâmico (RFC 7591): token de convite do administrador e um POST; volta um client_id novo.
echo; echo "== Registro dinâmico (RFC 7591): token de convite do administrador e um POST; volta um client_id novo."
TI=$($K create clients-initial-access -r curso -s count=1 -s expiration=300 -o | node -e "console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).token)")
curl -s -H "Authorization: Bearer $TI" -H "Content-Type: application/json" -d '{"client_name":"App por API","redirect_uris":["http://localhost:5000/callback"],"token_endpoint_auth_method":"none"}' http://localhost:8080/realms/curso/clients-registrations/openid-connect
