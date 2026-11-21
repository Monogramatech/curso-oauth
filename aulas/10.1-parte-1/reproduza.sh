#!/usr/bin/env bash
# Aula 10.1, Parte 1: Trust domains e JWT como grant (RFC 7523).
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
R=http://localhost:8080/realms; I=$R/curso/protocol/openid-connect; B=http://localhost:5400
# 1. a-teste: conta de serviço do domínio A, com o domínio B na audiência do token
echo; echo "== 1. a-teste: conta de serviço do domínio A, com o domínio B na audiência do token"
S=$($K get clients/$($K create clients -r curso -s clientId=a-teste -s serviceAccountsEnabled=true -s 'protocolMappers=[{"name":"aud-b","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.custom.audience":"http://localhost:5400","access.token.claim":"true"}}]' -i)/client-secret -r curso --fields value --format csv --noquotes)
v() { sed 's/.*"access_token":"//;s/".*//'; }; T=$(curl -s $I/token -u a-teste:$S -d grant_type=client_credentials | v)
# 2. Domínio B mínimo (5400): confia no emissor do realm curso e nas chaves que ele publica; aceita o JWT como pedido de token
echo; echo "== 2. Domínio B mínimo (5400): confia no emissor do realm curso e nas chaves que ele publica; aceita o JWT como pedido de token"
ISS=$R/curso JWKS=$I/certs B=$B node -e 'require("dns").setDefaultResultOrder("ipv4first");var c=require("crypto"),E=process.env,u={},k=c.generateKeyPairSync("ec",{namedCurve:"P-256"}).privateKey;
function d(x){return JSON.parse(Buffer.from(x,"base64url"))}function b(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var a=String(new URLSearchParams(t).get("assertion")).split("."),h=d(a[0]),p=d(a[1]),n=Date.now()/1e3|0;
function e(m){s.writeHead(400);s.end(JSON.stringify({error:"invalid_grant",error_description:m}))}if(p.iss==E.ISS)0;else return e("emissor fora da lista de confiança");
fetch(E.JWKS).then(function(x){return x.json()}).then(function(j){var w=j.keys.filter(function(y){return y.kid==h.kid})[0];
if(w&&c.verify("sha256",Buffer.from(a[0]+"."+a[1]),c.createPublicKey({key:w,format:"jwk"}),Buffer.from(a[2],"base64url")))0;else return e("assinatura");
if([].concat(p.aud).indexOf(E.B)==-1)return e("audiência");if(Math.max(0,n-p.exp+1))return e("vencido");if(u[p.jti])return e("jti já usado");u[p.jti]=1;
var q=b({alg:"ES256"})+"."+b({iss:E.B,sub:p.sub,aud:"api-b",iat:n,exp:n+300});
s.end(JSON.stringify({access_token:q+"."+c.sign("sha256",Buffer.from(q),{key:k,dsaEncoding:"ieee-p1363"}).toString("base64url"),token_type:"Bearer",expires_in:300}))})})}).listen(5400)' &
sleep 2
g() { curl -s $B/token -d grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer -d assertion=$1; echo; }
# 3. O token de A passa; o mesmo de novo, não (jti); um token do realm master, outro emissor, também não
echo; echo "== 3. O token de A passa; o mesmo de novo, não (jti); um token do realm master, outro emissor, também não"
g $T; g $T; g $(curl -s $R/master/protocol/openid-connect/token -d grant_type=password -d client_id=admin-cli -d username=admin -d password=admin | v)
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$($K get clients -r curso -q clientId=a-teste --fields id --format csv --noquotes) -r curso
