#!/usr/bin/env bash
# Aula 10.4, Parte 1: Identity chaining across domains.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.4-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
R=http://localhost:8080/realms; I=$R/curso/protocol/openid-connect; B=http://localhost:5410; U=urn:ietf:params:oauth; X=$U:grant-type:token-exchange; Y=$U:token-type:access_token
# 1. Domínio A: o destino, a API de pedidos com a troca e um token dos pedidos
echo; echo "== 1. Domínio A: o destino, a API de pedidos com a troca e um token dos pedidos"
au() { echo '[{"name":"a","protocol":"openid-connect","protocolMapper":"oidc-audience-mapper","config":{"included.client.audience":"'$1'","access.token.claim":"true"}}]'; }
mk() { $K get clients/$($K create clients -r curso -s clientId=$1 -s serviceAccountsEnabled=true -s "protocolMappers=$(au $2)" "${@:3}" -i)/client-secret -r curso --fields value --format csv --noquotes; }
$K create clients -r curso -s clientId=$B; P=$(mk pedidos-teste $B -s 'attributes."standard.token.exchange.enabled"=true'); A=$(mk portal-teste pedidos-teste)
v() { sed 's/.*"access_token":"//;s/".*//'; }; T=$(curl -s $I/token -u portal-teste:$A -d grant_type=client_credentials | v)
# 2. A troca: a concessão, com a audiência da transportadora
echo; echo "== 2. A troca: a concessão, com a audiência da transportadora"
G=$(curl -s $I/token -u pedidos-teste:$P -d grant_type=$X -d subject_token=$T -d subject_token_type=$Y -d audience=$B | v)
# 3. Transportadora mínima: o JWT como pedido, só com a audiência dela; o atalho aceita pedidos-teste
echo; echo "== 3. Transportadora mínima: o JWT como pedido, só com a audiência dela; o atalho aceita pedidos-teste"
ISS=$R/curso J=${I/localhost/127.0.0.1}/certs B=$B node -e 'var C=require("crypto"),E=process.env,u={},k=C.generateKeyPairSync("ec",{namedCurve:"P-256"}).privateKey;
function d(x){return JSON.parse(Buffer.from(x,"base64url"))}function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var f=new URLSearchParams(t),at=/exch/.test(f.get("grant_type")),
a=String(f.get("assertion")).split("."),h=d(a[0]),p=d(a[1]),n=Date.now()/1e3|0,m=[].concat(p.aud);
function e(x){s.writeHead(400);s.end(JSON.stringify({error:at?"invalid_request":"invalid_grant",error_description:x}))}if(p.iss==E.ISS)0;else return e("emissor");
fetch(E.J).then(function(x){return x.json()}).then(function(j){var w=j.keys.filter(function(y){return y.kid==h.kid})[0];
if(w&&C.verify("sha256",Buffer.from(a[0]+"."+a[1]),C.createPublicKey({key:w,format:"jwk"}),Buffer.from(a[2],"base64url")))0;else return e("assinatura");
if(m.indexOf(E.B)+1||at&&m.indexOf("pedidos-teste")+1)0;else return e("audiência");if(Math.max(0,n-p.exp+1))return e("vencido");if(u[p.jti])return e("jti já usado");
u[p.jti]=1;var q=b({alg:"ES256"})+"."+b({iss:E.B,sub:p.sub,aud:"api-entregas",iat:n,exp:n+300});
s.end(JSON.stringify({access_token:q+"."+C.sign("sha256",Buffer.from(q),{key:k,dsaEncoding:"ieee-p1363"}).toString("base64url")}))})})}).listen(5410)' &
sleep 2
g() { curl -s $B/token -d grant_type=$1 -d subject_token_type=$Y -d subject_token=$2 -d assertion=$2; echo; }; W=$U:grant-type:jwt-bearer
# 4. A concessão passa; de novo, não (jti); o token dos pedidos, não (audiência); pelo atalho, passa
echo; echo "== 4. A concessão passa; de novo, não (jti); o token dos pedidos, não (audiência); pelo atalho, passa"
g $W $G; g $W $G; g $W $T; g $X $T
kill %1; for c in $B pedidos-teste portal-teste; do $K delete clients/$($K get clients -r curso -q clientId=$c --fields id --format csv --noquotes) -r curso; done
