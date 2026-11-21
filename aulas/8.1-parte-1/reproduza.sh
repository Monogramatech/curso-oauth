#!/usr/bin/env bash
# Aula 8.1, Parte 1: CSRF, redirecionamento aberto e roubo de código.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/8.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. Um client com o endereço de retorno exato
echo; echo "== 1. Um client com o endereço de retorno exato"
C=$($K create clients -r curso -s clientId=album-exato -s publicClient=true -s 'redirectUris=["http://localhost:3000/callback"]' -i)
# 2. O endereço cadastrado abre a tela de login (200); outro caminho do mesmo site é recusado (400), sem redirecionamento
echo; echo "== 2. O endereço cadastrado abre a tela de login (200); outro caminho do mesmo site é recusado (400), sem redirecionamento"
curl -s -o /dev/null -w '%{http_code}\n' "$I/auth?response_type=code&client_id=album-exato&scope=openid&redirect_uri=http://localhost:3000/callback"
curl -s -o /dev/null -w '%{http_code}\n' "$I/auth?response_type=code&client_id=album-exato&scope=openid&redirect_uri=http://localhost:3000/ir"
# 3. O mesmo client com um asterisco no fim do endereço: agora qualquer caminho do site passa (200)
echo; echo "== 3. O mesmo client com um asterisco no fim do endereço: agora qualquer caminho do site passa (200)"
$K update clients/$C -r curso -s 'redirectUris=["http://localhost:3000/*"]'
curl -s -o /dev/null -w '%{http_code}\n' "$I/auth?response_type=code&client_id=album-exato&scope=openid&redirect_uri=http://localhost:3000/ir"
# 4. Um escopo que não existe: o Keycloak devolve o erro direto ao endereço do client, sem mostrar tela
echo; echo "== 4. Um escopo que não existe: o Keycloak devolve o erro direto ao endereço do client, sem mostrar tela"
curl -s -o /dev/null -w '%{redirect_url}\n' "$I/auth?response_type=code&client_id=album-exato&scope=inexistente&redirect_uri=http://localhost:3000/callback"
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
