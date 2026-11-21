#!/usr/bin/env bash
# Aula 9.2, Parte 1: Os parâmetros: subject_token, actor_token, audience, scope.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. O destino e quem troca (troca padrão ligada, audiência do destino). Sem navegador, o token de serviço de quem troca faz o papel do token recebido (exceção do Keycloak: um client pode trocar um token emitido para ele mesmo)
echo; echo "== 1. O destino e quem troca (troca padrão ligada, audiência do destino). Sem navegador, o token de serviço de quem troca faz o papel do token recebido (exceção do Keycloak: um client pode trocar um token emitido para ele mesmo)"
$K create clients -r curso -s clientId=pagamentos-teste
C=$($K create clients -r curso -s clientId=pedidos-teste -s serviceAccountsEnabled=true -s 'attributes."standard.token.exchange.enabled"=true' -s 'protocolMappers=[{"name":"aud","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.client.audience":"pagamentos-teste","access.token.claim":"true"}}]' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
T=$(curl -s $I/token -u pedidos-teste:$S -d grant_type=client_credentials | sed 's/.*"access_token":"//;s/".*//')
G=urn:ietf:params:oauth:grant-type:token-exchange; A=urn:ietf:params:oauth:token-type:access_token
d() { sed 's/.*"access_token":"//;s/".*//' | cut -d. -f2 | node -e "b=JSON.parse(Buffer.from(require('fs').readFileSync(0,'utf8').trim(),'base64url'));console.log(JSON.stringify({azp:b.azp,aud:b.aud,act:b.act||'nenhum'}))"; }
# 2. A troca, com o tipo do token e a audiência de destino
echo; echo "== 2. A troca, com o tipo do token e a audiência de destino"
curl -s $I/token -u pedidos-teste:$S -d grant_type=$G -d subject_token=$T -d subject_token_type=$A -d audience=pagamentos-teste | d
# 3. Sem o tipo do token: 400
echo; echo "== 3. Sem o tipo do token: 400"
curl -s $I/token -u pedidos-teste:$S -d grant_type=$G -d subject_token=$T -d audience=pagamentos-teste -w ' (status %{http_code})\n'
# 4. Um texto qualquer no actor token: o Keycloak 26.4 devolve um token igual, sem act
echo; echo "== 4. Um texto qualquer no actor token: o Keycloak 26.4 devolve um token igual, sem act"
curl -s $I/token -u pedidos-teste:$S -d grant_type=$G -d subject_token=$T -d subject_token_type=$A -d audience=pagamentos-teste -d actor_token=xyz -d actor_token_type=$A | d
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso; $K delete clients/$($K get clients -r curso -q clientId=pagamentos-teste --fields id --format csv --noquotes) -r curso
