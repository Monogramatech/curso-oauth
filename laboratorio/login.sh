#!/usr/bin/env bash
# Aula 0.2, passo 3: um login de verdade (Authorization Code com PKCE) e a primeira chamada com o token.
#   bash laboratorio/login.sh        (depois de bash laboratorio/preparo.sh)
source "$(dirname "$0")/comum.sh"
# 3. Um login de verdade (Authorization Code com PKCE)
pkce
echo "http://localhost:8080/realms/curso/protocol/openid-connect/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=openid%20fotos:publicar&state=abc123&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE
curl -s -o login.json http://localhost:8080/realms/curso/protocol/openid-connect/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE
cat login.json; echo
# O access_token da resposta vai em T:
T=$(node -p "JSON.parse(require('fs').readFileSync('login.json','utf8')).access_token")
curl -s http://localhost:8080/realms/curso/protocol/openid-connect/userinfo -H "Authorization: Bearer $T"
echo
