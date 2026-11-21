#!/usr/bin/env bash
# Aula 10.1, Parte 2: Federação de workloads: tokens de um provedor aceitos por outro.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
docker run -d --name kc-fed -p 8090:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.4.7 start-dev --features=client-auth-federated
until curl -sf -o /dev/null http://localhost:8090/realms/master; do sleep 3; done
K="docker exec kc-fed //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
# 1. A plataforma, simulada: gera a chave e assina dois JWTs de 5 minutos, o do job de produção e o do job de teste
echo; echo "== 1. A plataforma, simulada: gera a chave e assina dois JWTs de 5 minutos, o do job de produção e o do job de teste"
set -- $(node -e 'var c=require("crypto"),k=c.generateKeyPairSync("ec",{namedCurve:"P-256"}),n=Date.now()/1e3|0;
function b(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function j(s){var e=b({alg:"ES256",typ:"JWT",kid:"plataforma-1"})+"."+b({iss:"http://plataforma:5600",sub:"job:loja/relatorios:ambiente:"+s,aud:"http://localhost:8090/realms/curso",iat:n,exp:n+300,jti:c.randomUUID()});
return e+"."+c.sign("sha256",Buffer.from(e),{key:k.privateKey,dsaEncoding:"ieee-p1363"}).toString("base64url")}
console.log(k.publicKey.export({type:"spki",format:"der"}).toString("base64"),j("producao"),j("teste"))')
# 2. O realm, o provedor "plataforma" (com a chave pública da plataforma) e o serviço que só aceita o sub do job de produção
echo; echo "== 2. O realm, o provedor 'plataforma' (com a chave pública da plataforma) e o serviço que só aceita o sub do job de produção"
$K create realms -s realm=curso -s enabled=true -s sslRequired=none
$K create identity-provider/instances -r curso -s alias=plataforma -s providerId=oidc -s config.issuer=http://plataforma:5600 -s config.validateSignature=true -s config.useJwksUrl=false -s config.publicKeySignatureVerifier=$1 -s config.supportsClientAssertions=true -s config.clientId=x -s config.clientSecret=x -s config.authorizationUrl=http://plataforma:5600/a -s config.tokenUrl=http://plataforma:5600/t
$K create clients -r curso -s clientId=relatorios-fed -s serviceAccountsEnabled=true -s clientAuthenticatorType=federated-jwt -s 'attributes."jwt.credential.issuer"=plataforma' -s 'attributes."jwt.credential.sub"=job:loja/relatorios:ambiente:producao'
# 3. O job de produção recebe o token, sem segredo; o mesmo JWT de novo, não (reuso); o job de teste, também não (401)
echo; echo "== 3. O job de produção recebe o token, sem segredo; o mesmo JWT de novo, não (reuso); o job de teste, também não (401)"
p() { curl -s http://localhost:8090/realms/curso/protocol/openid-connect/token -d grant_type=client_credentials -d client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer -d client_assertion=$1; echo; }
p $2; p $2; p $3
# Desfaz
echo; echo "== Desfaz"
docker rm -f kc-fed
