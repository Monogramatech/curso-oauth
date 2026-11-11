#!/usr/bin/env bash
# Aula 2.1, Parte 1: Resource owner, client, authorization server, resource server.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/2.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
# Os papéis dentro do token: iss (authorization server), azp (client), sub (resource owner) e scope. Repare: não há aud.
echo; echo "== Os papéis dentro do token: iss (authorization server), azp (client), sub (resource owner) e scope. Repare: não há aud."
node -e "const c=JSON.parse(Buffer.from(process.argv[1].split('.')[1],'base64url'));console.log({iss:c.iss,azp:c.azp,sub:c.sub,scope:c.scope,aud:c.aud})" "$T"
# O resource server do laboratório é o próprio Keycloak (userinfo): ele responde com o mesmo sub.
echo; echo "== O resource server do laboratório é o próprio Keycloak (userinfo): ele responde com o mesmo sub."
curl -s http://localhost:8080/realms/curso/protocol/openid-connect/userinfo -H "Authorization: Bearer $T"
