#!/usr/bin/env bash
# Aula 3.2, Parte 2: Conferir as claims em ordem.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/3.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"; curl -s $A/certs -o jwks.json
# O validador em sete portões, um por vez (o último número é a folga, em segundos)
echo; echo "== O validador em sete portões, um por vez (o último número é a folga, em segundos)"
valida() { node -e "const c=require('crypto'),a=process.argv,p=a[1].split('.'),d=function(i){return JSON.parse(Buffer.from(p[i],'base64url'))},h=d(0),b=d(1);let k;const r={alg:function(){return h.alg==='RS256'},chave:function(){k=JSON.parse(require('fs').readFileSync('jwks.json')).keys.find(function(x){return x.kid===h.kid&&x.use==='sig'});return Boolean(k)},assinatura:function(){return c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url'))},typ:function(){return h.typ==='at+jwt'||h.typ==='application/at+jwt'},iss:function(){return b.iss===a[2]},aud:function(){return [].concat(b.aud||[]).includes(a[3])},exp:function(){return Math.sign(b.exp+Number(a[4])-Date.now()/1000)===1}};for(const n in r){const ok=r[n]();console.log((ok?'ok':'falhou')+' · '+n);if(ok===false){console.log('recusado');process.exit()}}console.log('aceito')" "$1" http://localhost:8080/realms/curso "$2" "$3"; }
# Cópia alterada do token: alg vira none; aud muda o corpo
echo; echo "== Cópia alterada do token: alg vira none; aud muda o corpo"
copia() { node -e "const p=process.argv[1].split('.'),j=function(i){return JSON.parse(Buffer.from(p[i],'base64url'))},e=function(o){return Buffer.from(JSON.stringify(o)).toString('base64url')};if(process.argv[2]==='alg'){const h=j(0);h.alg='none';console.log(e(h)+'.'+p[1]+'.')}else{const b=j(1);b.aud='api-de-pagamentos';console.log(p[0]+'.'+e(b)+'.'+p[2])}" "$1" "$2"; }
# O access token padrão e o ID token param no typ
echo; echo "== O access token padrão e o ID token param no typ"
valida "$T" api-de-fotos 0; valida "$I" api-de-fotos 0
# Perfil da RFC 9068, vida de 30 s: entre pelo endereço e troque o code
echo; echo "== Perfil da RFC 9068, vida de 30 s: entre pelo endereço e troque o code"
C=$($K get clients -r curso -q clientId=app-de-fotos --fields id --format csv --noquotes)
$K update clients/$C -r curso -s 'attributes."access.token.header.type.rfc9068"=true' -s 'attributes."access.token.lifespan"=30'
M=$($K create clients/$C/protocol-mappers/models -r curso -s name=aud-api -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-fotos' -s 'config."access.token.claim"=true' -i)
echo "$A/auth?response_type=code&client_id=app-de-fotos&redirect_uri=http://localhost:3000/callback&scope=openid&state=abc123&code_challenge=$CH&code_challenge_method=S256"
pede_code CODE3
T3=$(curl -s $A/token -d grant_type=authorization_code -d client_id=app-de-fotos -d redirect_uri=http://localhost:3000/callback -d code_verifier=$V -d code=$CODE3 | node -e "console.log(JSON.parse(require('fs').readFileSync(0)).access_token)")
# Aceito; na API de pagamentos, para no aud; corpo alterado, na assinatura; alg trocado, no alg
echo; echo "== Aceito; na API de pagamentos, para no aud; corpo alterado, na assinatura; alg trocado, no alg"
valida "$T3" api-de-fotos 0; valida "$T3" api-de-pagamentos 0
valida "$(copia "$T3" aud)" api-de-pagamentos 0; valida "$(copia "$T3" alg)" api-de-fotos 0
# Vencido: para no exp; com folga de 60 s, passa
echo; echo "== Vencido: para no exp; com folga de 60 s, passa"
sleep 35; valida "$T3" api-de-fotos 0; valida "$T3" api-de-fotos 60
# Desfaz
echo; echo "== Desfaz"
$K update clients/$C -r curso -s 'attributes."access.token.header.type.rfc9068"=false' -s 'attributes."access.token.lifespan"=300'
$K delete clients/$C/protocol-mappers/models/$M -r curso
