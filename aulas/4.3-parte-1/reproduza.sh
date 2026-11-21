#!/usr/bin/env bash
# Aula 4.3, Parte 1: Device Authorization Grant: TV, CLI e IoT.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; G=grant_type=urn:ietf:params:oauth:grant-type:device_code
# 1. A TV: sem segredo, sem endereço de retorno, com o Device Code ligado
echo; echo "== 1. A TV: sem segredo, sem endereço de retorno, com o Device Code ligado"
TV=$($K create clients -r curso -s clientId=tv-de-fotos -s "name=Fotos na TV" -s publicClient=true -s standardFlowEnabled=false -s consentRequired=true -s 'attributes."oauth2.device.authorization.grant.enabled"=true' -s 'defaultClientScopes=["basic","profile"]' -i)
# 2. O pedido do código: anote o user_code e o verification_uri
echo; echo "== 2. O pedido do código: anote o user_code e o verification_uri"
curl -s $O/auth/device -d client_id=tv-de-fotos -d scope=openid | tee d.json; echo
DC=$(node -p "require('./d.json').device_code")
# 3. A consulta antes da aprovação: authorization_pending; de novo, na hora: slow_down
echo; echo "== 3. A consulta antes da aprovação: authorization_pending; de novo, na hora: slow_down"
curl -s $O/token -d $G -d client_id=tv-de-fotos -d device_code=$DC; echo
curl -s $O/token -d $G -d client_id=tv-de-fotos -d device_code=$DC; echo
# 4. No navegador (o celular): abra o verification_uri, digite o user_code, entre com voce / teste123 e aprove (Yes).
echo; echo "== 4. No navegador (o celular): abra o verification_uri, digite o user_code, entre com voce / teste123 e aprove (Yes)."
# 5. Depois de aprovar: o token. O sub é o usuário voce; o azp, a TV
echo; echo "== 5. Depois de aprovar: o token. O sub é o usuário voce; o azp, a TV"
curl -s $O/token -d $G -d client_id=tv-de-fotos -d device_code=$DC | tee t.json; echo
node -p "JSON.parse(Buffer.from(require('./t.json').access_token.split('.')[1],'base64url'))"
# 6. O mesmo device_code de novo: invalid_grant
echo; echo "== 6. O mesmo device_code de novo: invalid_grant"
curl -s $O/token -d $G -d client_id=tv-de-fotos -d device_code=$DC; echo
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$TV -r curso; rm -f d.json t.json
