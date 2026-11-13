#!/usr/bin/env bash
# Aula 4.2, Parte 1: Serviço falando com serviço, sem usuário.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso; A=$I/protocol/openid-connect/token; G="-d grant_type=client_credentials"
corpo() { node -p "JSON.parse(Buffer.from(require('fs').readFileSync(0,'utf8').split('.')[1],'base64url'))"; }
# 1. O escopo estoque:ler (aud api-de-estoque) e o job confidencial, com conta de serviço
echo; echo "== 1. O escopo estoque:ler (aud api-de-estoque) e o job confidencial, com conta de serviço"
E=$($K create client-scopes -r curso -s name=estoque:ler -s protocol=openid-connect -i)
$K create client-scopes/$E/protocol-mappers/models -r curso -s name=aud -s protocol=openid-connect -s protocolMapper=oidc-audience-mapper -s 'config."included.custom.audience"=api-de-estoque' -s 'config."access.token.claim"=true'
J=$($K create clients -r curso -s clientId=job-de-pedidos -s publicClient=false -s serviceAccountsEnabled=true -s standardFlowEnabled=false -s 'defaultClientScopes=["basic","service_account"]' -s 'optionalClientScopes=["estoque:ler"]' -i)
S=$($K get clients/$J/client-secret -r curso --fields value --format csv --noquotes)
# 2. O pedido (segredo no Basic): sem refresh_token; o sub é a conta de serviço
echo; echo "== 2. O pedido (segredo no Basic): sem refresh_token; o sub é a conta de serviço"
curl -s -u job-de-pedidos:$S $A $G -d scope=estoque:ler | tee t.json; echo
node -p "require('./t.json').access_token" | corpo; $K get clients/$J/service-account-user -r curso --fields id,username
# 3. Segredo no corpo: 200. Errado e app público: 401. Escopo fora do job: 400
echo; echo "== 3. Segredo no corpo: 200. Errado e app público: 401. Escopo fora do job: 400"
for x in "-d client_id=job-de-pedidos -d client_secret=$S" "-u job-de-pedidos:errado" "-d client_id=app-de-fotos" "-u job-de-pedidos:$S -d scope=fotos:publicar"; do curl -s $A $G $x | head -c 120; echo; done
# 4. O mesmo job com chave: o JWKS público vai para o registro
echo; echo "== 4. O mesmo job com chave: o JWKS público vai para o registro"
JW=$(node -e "const c=require('crypto'),k=c.generateKeyPairSync('rsa',{modulusLength:2048});require('fs').writeFileSync('chave.pem',k.privateKey.export({type:'pkcs8',format:'pem'}));console.log(JSON.stringify(JSON.stringify({keys:[Object.assign(k.publicKey.export({format:'jwk'}),{kid:'job-chave-1',use:'sig'})]})))")
$K update clients/$J -r curso -s clientAuthenticatorType=client-jwt -s 'attributes."use.jwks.string"=true' -s 'attributes."jwks.string"='"$JW"
assina() { node -e "const c=require('crypto');function b(o){return Buffer.from(JSON.stringify(o)).toString('base64url')}const t=(Date.now()/1e3|0)-$1,h=b({alg:'RS256',typ:'client-authentication+jwt',kid:'job-chave-1'})+'.'+b({iss:'job-de-pedidos',sub:'job-de-pedidos',aud:'$I',jti:c.randomUUID(),iat:t,exp:t+60});console.log(h+'.'+c.sign('sha256',Buffer.from(h),require('fs').readFileSync('chave.pem','utf8')).toString('base64url'))"; }
T="-d client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer -d client_assertion"; AS=$(assina 0); echo $AS | corpo
# A assertion: 200. Repetida, vencida e o segredo: 400
echo; echo "== A assertion: 200. Repetida, vencida e o segredo: 400"
curl -s -o /dev/null -w "%{http_code}\n" $A $G $T=$AS
curl -s $A $G $T=$AS; echo; curl -s $A $G $T=$(assina 120); echo; curl -s -u job-de-pedidos:$S $A $G; echo
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$J -r curso; $K delete client-scopes/$E -r curso; rm -f t.json chave.pem
