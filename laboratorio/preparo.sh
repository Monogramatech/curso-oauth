#!/usr/bin/env bash
# Aula 0.2: o laboratório do curso. Keycloak 26.4 em Docker, só em localhost:8080, com o realm "curso" (senhas de teste).
#   bash laboratorio/preparo.sh      -> sobe o contêiner "kc" e monta o realm
#   docker rm -f kc                  -> apaga o laboratório (para recomeçar do zero)
export MSYS_NO_PATHCONV=1
if docker ps -a --format '{{.Names}}' | grep -qx kc; then echo "Já existe um contêiner kc. Para recomeçar do zero: docker rm -f kc"; exit 1; fi
# 1. Keycloak 26.4 em Docker (no Windows: WSL ou Git Bash)
docker run -d --name kc -p 127.0.0.1:8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.4 start-dev
echo "Esperando o Keycloak subir (até 3 min)..."
for i in $(seq 1 90); do curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/realms/master | grep -q 200 && break; sleep 2; done
# 2. Monta o realm (senhas de teste)
K="docker exec kc //opt/keycloak/bin/kcadm.sh"
$K config credentials --server http://localhost:8080 --realm master --user admin --password admin
$K create realms -s realm=curso -s enabled=true -s accessTokenLifespan=300
$K create users -r curso -s username=voce -s enabled=true -s email=voce@exemplo.test -s firstName=Voce -s lastName=Aluno
$K set-password -r curso --username voce --new-password teste123
$K create clients -r curso -s clientId=app-de-fotos -s publicClient=true -s consentRequired=true -s 'redirectUris=["http://localhost:3000/callback"]' -s 'attributes."pkce.code.challenge.method"=S256'
S=$($K create client-scopes -r curso -s name=fotos:publicar -s protocol=openid-connect -s 'attributes."include.in.token.scope"=true' -s 'attributes."consent.screen.text"=Publicar fotos no seu perfil' -i)
C=$($K get clients -r curso -q clientId=app-de-fotos --fields id --format csv --noquotes)
$K update clients/$C/optional-client-scopes/$S -r curso
echo "Pronto: realm curso, usuário voce / teste123, app de fotos. Próximo passo: bash laboratorio/login.sh"
