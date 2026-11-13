#!/usr/bin/env bash
# Aula 1.2, Parte 1: JWK, JWKS, kid e rotação de chaves.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/1.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
# O caminho até as chaves: issuer, descoberta, JWKS
echo; echo "== O caminho até as chaves: issuer, descoberta, JWKS"
curl -s http://localhost:8080/realms/curso/.well-known/openid-configuration | grep -o '"jwks_uri":"[^"]*"'
curl -s http://localhost:8080/realms/curso/protocol/openid-connect/certs
# Rotação: uma chave RS256 nova, com prioridade maior que a antiga (100)
echo; echo "== Rotação: uma chave RS256 nova, com prioridade maior que a antiga (100)"
$K create components -r curso -s name=rsa-nova -s providerId=rsa-generated -s providerType=org.keycloak.keys.KeyProvider -s 'config.priority=["200"]'
$K get keys -r curso
# Faça um login novo (passo 3 da Aula 0.2): o kid no cabeçalho do token agora é o da chave nova.
echo; echo "== Um login novo: o kid no cabeçalho do token agora é o da chave nova."
login_lab
node -e "console.log('kid do token novo:', JSON.parse(Buffer.from(process.argv[1].split('.')[0],'base64url')).kid)" "$T"
# Depois, a antiga vira passiva e, por fim, sai da lista (ID: o id da chave "rsa-generated"):
echo; echo "== Depois, a antiga vira passiva e, por fim, sai da lista (ID: o id da chave 'rsa-generated'):"
$K get components -r curso -q type=org.keycloak.keys.KeyProvider --fields id,name
ID=$($K get components -r curso -q type=org.keycloak.keys.KeyProvider --fields id,name --format csv --noquotes | grep ',rsa-generated$' | cut -d, -f1)
$K update components/$ID -r curso -s 'config.active=["false"]'
$K update components/$ID -r curso -s 'config.enabled=["false"]'
curl -s http://localhost:8080/realms/curso/protocol/openid-connect/certs | node -e "console.log('kids no JWKS agora:', JSON.parse(require('fs').readFileSync(0,'utf8')).keys.map(function(k){return k.kid.slice(0,8)+'… ('+k.alg+')'}).join(', '))"
