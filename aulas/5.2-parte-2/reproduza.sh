#!/usr/bin/env bash
# Aula 5.2, Parte 2: Avisar os outros apps: front-channel e back-channel logout.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/5.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://localhost:6001/callback
# 1. O app de notas, confidencial, com o endereço de logout do canal de trás
echo; echo "== 1. O app de notas, confidencial, com o endereço de logout do canal de trás"
C=$($K create clients -r curso -s clientId=app-de-notas -s 'redirectUris=["http://localhost:6001/callback"]' -s 'attributes."backchannel.logout.url"=http://host.docker.internal:6001/sair' -s 'attributes."backchannel.logout.session.required"=true' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
# 2. O back-end do app de notas: imprime as claims do logout token e responde 200. Se o Windows perguntar, permita o node.
echo; echo "== 2. O back-end do app de notas: imprime as claims do logout token e responde 200. Se o Windows perguntar, permita o node."
node -e "require('http').createServer(function(q,s){let b='';q.on('data',function(d){b+=d});q.on('end',function(){console.log(Buffer.from(new URLSearchParams(b).get('logout_token').split('.')[1],'base64url').toString());s.writeHead(200,{'Cache-Control':'no-store'});s.end()})}).listen(6001)" &
# 3. O login: abra o endereço, entre com voce / teste123 e copie o code da barra. Em menos de 1 minuto:
echo; echo "== 3. O login: abra o endereço, entre com voce / teste123 e copie o code da barra. Em menos de 1 minuto:"
echo "$O/auth?response_type=code&client_id=app-de-notas&redirect_uri=$R&scope=openid&state=abc"
pede_code CODE
curl -s $O/token -d grant_type=authorization_code -d client_id=app-de-notas -d client_secret=$S -d redirect_uri=$R -d code=$CODE -o t.json
# 4. O logout com a dica: o servidor avisa o app de notas, e o passo 2 imprime o logout token (sem nonce, com events)
echo; echo "== 4. O logout com a dica: o servidor avisa o app de notas, e o passo 2 imprime o logout token (sem nonce, com events)"
curl -s -o /dev/null -w "%{http_code}\n" "$O/logout?id_token_hint=$(node -p "require('./t.json').id_token")"
# No Linux sem Docker Desktop, o contêiner do passo 1 da Aula 0.2 precisa de --add-host=host.docker.internal:host-gateway
echo; echo "== No Linux sem Docker Desktop, o contêiner do passo 1 da Aula 0.2 precisa de --add-host=host.docker.internal:host-gateway"
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso; rm -f t.json
