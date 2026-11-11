#!/usr/bin/env bash
# Aula 2.2, Parte 2: Escopo, consentimento e o parâmetro state.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/2.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
# Comece sem consentimento guardado (se você já fez o login da Aula 0.2, o Keycloak lembraria e pularia a tela).
echo; echo "== Comece sem consentimento guardado (se você já fez o login da Aula 0.2, o Keycloak lembraria e pularia a tela)."
K="docker exec kc /opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
U=$($K get users -r curso -q username=voce --fields id --format csv --noquotes)
$K delete users/$U/consents/app-de-fotos -r curso
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64)
CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
A="http://localhost:8080/realms/curso/protocol/openid-connect"
P="response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&code_challenge=$CH&code_challenge_method=S256"
# Entre com voce / teste123 e clique em Cancelar: a barra volta com error=access_denied e o mesmo state.
echo; echo "== Entre com voce / teste123 e clique em Cancelar: a barra volta com error=access_denied e o mesmo state."
echo "$A/auth?$P&scope=openid%20fotos:publicar&state=abc123"
# Abra de novo e clique em Permitir. Troque o code e veja o scope da resposta: veio mais do que o pedido.
echo; echo "== Abra de novo e clique em Permitir. Troque o code e veja o scope da resposta: veio mais do que o pedido."
echo "$A/auth?$P&scope=openid%20fotos:publicar&state=abc123"
pede_code CODE
curl -s $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE | node -e "console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).scope)"
# O consentimento ficou guardado, com os escopos concedidos.
echo; echo "== O consentimento ficou guardado, com os escopos concedidos."
$K get users/$U/consents -r curso
# Um escopo desconhecido: a barra volta com error=invalid_scope.
echo; echo "== Um escopo desconhecido: a barra volta com error=invalid_scope."
echo "$A/auth?$P&scope=openid%20fotos:apagar&state=abc123"
# Sem state: o servidor devolve o code assim mesmo. Quem confere o state é o app.
echo; echo "== Sem state: o servidor devolve o code assim mesmo. Quem confere o state é o app."
echo "$A/auth?$P&scope=openid%20fotos:publicar"
