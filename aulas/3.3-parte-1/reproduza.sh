#!/usr/bin/env bash
# Aula 3.3, Parte 1: aud e scope: destino e poder.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
pkce
K="docker exec kc /opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"
url() { echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=$1&state=abc123&code_challenge=$CH&code_challenge_method=S256"; }
mostra() { node -e "const r=JSON.parse(require('fs').readFileSync('t.json','utf8')),b=JSON.parse(Buffer.from(r.access_token.split('.')[1],'base64url'));console.log('aud:',b.aud,'| scope:',b.scope)"; }
troca() { curl -s -o t.json $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$1; mostra; }
# Dois destinos (só nomes no aud): fotos:publicar e pagamentos:ler
echo; echo "== Dois destinos (só nomes no aud): fotos:publicar e pagamentos:ler"
F=$($K get client-scopes -r curso --fields id,name --format csv --noquotes | grep fotos:publicar | cut -d, -f1)
$K create client-scopes/$F/protocol-mappers/models -r curso -s name=aud-fotos -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-fotos' -s 'config."access.token.claim"=true'
P=$($K create client-scopes -r curso -s name=pagamentos:ler -s protocol=openid-connect -s 'attributes."include.in.token.scope"=true' -s 'attributes."consent.screen.text"=Ler seus pagamentos' -i)
$K create client-scopes/$P/protocol-mappers/models -r curso -s name=aud-pag -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-pagamentos' -s 'config."access.token.claim"=true'
C=$($K get clients -r curso -q clientId=app-de-fotos --fields id --format csv --noquotes); $K update clients/$C/optional-client-scopes/$P -r curso
# Só fotos:publicar: aud api-de-fotos
echo; echo "== Só fotos:publicar: aud api-de-fotos"
url openid%20fotos:publicar
pede_code CODE1
troca $CODE1
# Os dois escopos: um token, duas APIs no aud
echo; echo "== Os dois escopos: um token, duas APIs no aud"
url openid%20fotos:publicar%20pagamentos:ler
pede_code CODE2
troca $CODE2
# Sem novo login: o refresh token pede só fotos:publicar; o aud fica só com a API de fotos
echo; echo "== Sem novo login: o refresh token pede só fotos:publicar; o aud fica só com a API de fotos"
R=$(node -p "JSON.parse(require('fs').readFileSync('t.json','utf8')).refresh_token")
curl -s -o t.json $A/token -d grant_type=refresh_token -d client_id=app-de-fotos -d refresh_token=$R --data-urlencode "scope=openid fotos:publicar"; mostra
# O resource da RFC 8707: este Keycloak ignora, e o token sai sem aud
echo; echo "== O resource da RFC 8707: este Keycloak ignora, e o token sai sem aud"
echo "$(url openid)&resource=http://localhost:5000/fotos"
pede_code CODE3
troca $CODE3
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C/optional-client-scopes/$P -r curso; $K delete client-scopes/$P -r curso
$K delete client-scopes/$F/protocol-mappers/models/$($K get client-scopes/$F/protocol-mappers/models -r curso --fields id,name --format csv --noquotes | grep aud-fotos | cut -d, -f1) -r curso
