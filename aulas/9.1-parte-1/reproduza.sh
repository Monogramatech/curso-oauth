#!/usr/bin/env bash
# Aula 9.1, Parte 1: Token passthrough e client credentials: o que cada um apaga na cadeia.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. O serviço de pedidos como client: só client credentials, com a audiência de pagamentos
echo; echo "== 1. O serviço de pedidos como client: só client credentials, com a audiência de pagamentos"
C=$($K create clients -r curso -s clientId=pedidos-teste -s serviceAccountsEnabled=true -s standardFlowEnabled=false -s 'protocolMappers=[{"name":"aud-pagamentos","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.custom.audience":"pagamentos","access.token.claim":"true"}}]' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
# 2. O token do serviço por dentro: o client, a audiência e o usuário, que é a conta de serviço, e não uma pessoa
echo; echo "== 2. O token do serviço por dentro: o client, a audiência e o usuário, que é a conta de serviço, e não uma pessoa"
T=$(curl -s $I/token -u pedidos-teste:$S -d grant_type=client_credentials | sed 's/.*"access_token":"//;s/".*//')
echo $T | cut -d. -f2 | node -e "var b=JSON.parse(Buffer.from(require('fs').readFileSync(0,'utf8').trim(),'base64url'));console.log({azp:b.azp,aud:b.aud,usuario:b.preferred_username})"
# 3. Um serviço de pagamentos mínimo (deixe rodando): anota o que o token diz e o que o cabeçalho diz
echo; echo "== 3. Um serviço de pagamentos mínimo (deixe rodando): anota o que o token diz e o que o cabeçalho diz"
node -e "require('http').createServer(function(q,r){var m=/^Bearer (\S+)$/i.exec(q.headers.authorization||''),b=m?JSON.parse(Buffer.from(m[1].split('.')[1],'base64url')):{};console.log('o token diz: azp='+b.azp+' | o cabecalho diz: '+(q.headers['x-usuario']||'nada'));r.end('ok\n')}).listen(5101,'127.0.0.1')" &
sleep 1
# 4. Pedidos cobra com o token dele e o nome da pessoa num cabeçalho: a pessoa só existe no cabeçalho, sem assinatura
echo; echo "== 4. Pedidos cobra com o token dele e o nome da pessoa num cabeçalho: a pessoa só existe no cabeçalho, sem assinatura"
curl -s -H "Authorization: Bearer $T" -H "X-Usuario: voce" 127.0.0.1:5101/cobrancas -d valor=10.00
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso
