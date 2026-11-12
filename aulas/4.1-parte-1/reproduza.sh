#!/usr/bin/env bash
# Aula 4.1, Parte 1: O fluxo completo, requisição por requisição.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
pkce
# Para ver as requisições do navegador: F12, aba Rede, "Preservar log" marcado e o filtro "Doc" (sem os arquivos da página).
echo; echo "== Para ver as requisições do navegador: F12, aba Rede, 'Preservar log' marcado e o filtro 'Doc' (sem os arquivos da página)."
K="docker exec kc /opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"
url() { echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=${1:-http://localhost:3000/callback}&scope=${2:-openid%20fotos:publicar}&state=abc123&code_challenge=$CH&code_challenge_method=S256"; }
troca() { curl -s -o $2 -w "%{http_code} " $A/token -d grant_type=authorization_code -d client_id=${3:-app-de-fotos} -d redirect_uri=${4:-http://localhost:3000/callback} -d code_verifier=$V -d code=$1; node -e "const j=JSON.parse(require('fs').readFileSync('$2','utf8'));console.log(j.error ? j.error+' · '+j.error_description : 'tokens · '+j.scope)"; }
api() { curl -s -o /dev/null -w "%{http_code}\n" $A/userinfo -H "Authorization: Bearer $(node -p "JSON.parse(require('fs').readFileSync('$1','utf8')).access_token")"; }
# Requisição 1: o status e os cookies que o servidor grava
echo; echo "== Requisição 1: o status e os cookies que o servidor grava"
curl -s -o /dev/null -D - "$(url)" | grep -iE "^HTTP|^set-cookie" | cut -d= -f1
# Apague o consentimento do login anterior (sem login anterior, sai "Resource not found": tudo bem). Depois, um login (entre e permita), a troca (requisição 5) e a API (6)
echo; echo "== Apague o consentimento do login anterior (sem login anterior, sai 'Resource not found': tudo bem). Depois, um login (entre e permita), a troca (requisição 5) e a API (6)"
$K delete users/$($K get users -r curso -q username=voce --fields id --format csv --noquotes)/consents/app-de-fotos -r curso
url
pede_code CODE1
troca $CODE1 t.json
api t.json
# O mesmo code de novo: recusa, e o token da primeira troca para de valer
echo; echo "== O mesmo code de novo: recusa, e o token da primeira troca para de valer"
troca $CODE1 t2.json
api t.json
# Na MESMA janela, abra o endereço de novo: volta direto, sem senha. O code, com outro client:
echo; echo "== Na MESMA janela, abra o endereço de novo: volta direto, sem senha. O code, com outro client:"
url
pede_code CODE2
troca $CODE2 t2.json account-console
# De novo na mesma janela; a troca com outro endereço de retorno
echo; echo "== De novo na mesma janela; a troca com outro endereço de retorno"
url
pede_code CODE3
troca $CODE3 t2.json app-de-fotos http://localhost:3000/outra
# De novo; o code vence em 60 s
echo; echo "== De novo; o code vence em 60 s"
url
pede_code CODE4
sleep 65; troca $CODE4 t2.json
# Onde o erro aparece: página do servidor (400, sem redirecionar) e volta ao app com error
echo; echo "== Onde o erro aparece: página do servidor (400, sem redirecionar) e volta ao app com error"
curl -s -o /dev/null -w "%{http_code} [%{redirect_url}]\n" "$(url http://localhost:3000/outra)"
curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" "$(url "" openid%20fotos:apagar)"
