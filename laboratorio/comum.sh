# Funções comuns dos scripts das aulas. Cada aulas/<parte>/reproduza.sh começa com: source laboratorio/comum.sh
# O laboratório precisa estar no ar (bash laboratorio/preparo.sh). Senhas de teste, só em localhost.
export MSYS_NO_PATHCONV=1   # Git Bash no Windows: não converter os caminhos do docker exec
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$RAIZ/.trabalho" && cd "$RAIZ/.trabalho"   # os arquivos que os comandos gravam (t.json, jwks.json…) ficam aqui
for p in curl node openssl docker; do command -v $p > /dev/null || { echo "Falta o programa: $p"; exit 1; }; done
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/realms/curso | grep -q 200 || {
  echo "O laboratório não está no ar. Rode antes: bash laboratorio/preparo.sh"; exit 1; }
# O par do PKCE (Aula 1.1): V, o verifier; CH, o challenge.
pkce() {
  V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64)
  CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
}
# Espera o code que você copia da barra de endereço. Uso: pede_code CODE
pede_code() {
  echo "Abra o endereço acima numa janela anônima, entre com voce / teste123 e permita."
  echo "A página de retorno não abre, mas a barra de endereço traz o code. Cole aqui o code e tecle Enter:"
  read -r "$1"
  printf -v "$1" '%s' "${!1%$'\r'}"   # tira o fim de linha do Windows, se vier junto
}
# O login do passo 3 da Aula 0.2: deixa o access token em T, o refresh token em R e o id_token em I.
login_lab() {
  pkce
  echo "http://localhost:8080/realms/curso/protocol/openid-connect/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=openid%20fotos:publicar&state=abc123&code_challenge=$CH&code_challenge_method=S256"
  pede_code CODE
  curl -s -o login.json http://localhost:8080/realms/curso/protocol/openid-connect/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE
  T=$(node -p "JSON.parse(require('fs').readFileSync('login.json','utf8')).access_token || ''")
  R=$(node -p "JSON.parse(require('fs').readFileSync('login.json','utf8')).refresh_token || ''")
  I=$(node -p "JSON.parse(require('fs').readFileSync('login.json','utf8')).id_token || ''")
  [ -n "$T" ] || { echo "O login falhou:"; cat login.json; echo; exit 1; }
  echo "Login feito: o access token está em T (vence em 5 min)."
}
