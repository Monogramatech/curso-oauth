#!/usr/bin/env bash
# Aula 9.2, Parte 2: Impersonificação × delegação.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect; A=urn:ietf:params:oauth:token-type:access_token
# 1. pedidos-teste (quem age) e pessoa-teste (faz o papel da pessoa)
echo; echo "== 1. pedidos-teste (quem age) e pessoa-teste (faz o papel da pessoa)"
P=$($K create clients -r curso -s clientId=pedidos-teste -s serviceAccountsEnabled=true -i); SP=$($K get clients/$P/client-secret -r curso --fields value --format csv --noquotes)
Q=$($K create clients -r curso -s clientId=pessoa-teste -s serviceAccountsEnabled=true -i); SQ=$($K get clients/$Q/client-secret -r curso --fields value --format csv --noquotes)
t() { curl -s $I/token -u $1 -d grant_type=client_credentials | sed 's/.*"access_token":"//;s/".*//'; }
T=$(t pessoa-teste:$SQ); TA=$(t pedidos-teste:$SP)
# 2. Servidor de troca mínimo (porta 5200): confere os tokens na introspecção; act só com actor token de quem se autenticou
echo; echo "== 2. Servidor de troca mínimo (porta 5200): confere os tokens na introspecção; act só com actor token de quem se autenticou"
I=$I A=$A node -e 'require("dns").setDefaultResultOrder("ipv4first");var c=require("crypto"),k=c.randomBytes(32);function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function q(t,a){return fetch(process.env.I+"/token/introspect",{method:"POST",headers:{authorization:a,"content-type":"application/x-www-form-urlencoded"},body:"token="+t}).then(function(r){return r.json()})}
require("http").createServer(function(r,s){var d="";r.on("data",function(x){d+=x});r.on("end",function(){var p=new URLSearchParams(d),a=r.headers.authorization,A=p.get("actor_token");
function e(m){s.writeHead(400);s.end(JSON.stringify({error:"invalid_request",error_description:m}))}Promise.all([q(p.get("subject_token"),a),A?q(A,a):{active:true}]).then(function(v){
if((v[0].active&&v[1].active)?0:1)return e("token invalido");if(A&&(v[1].client_id==Buffer.from(a.slice(6),"base64").toString().split(":")[0])==false)return e("actor_token de outro client");
var b={iss:"http://localhost:5200",sub:v[0].sub,aud:p.get("audience"),exp:(Date.now()/1e3|0)+300};if(A)b.act={sub:v[1].sub,client_id:v[1].client_id};var h=u({alg:"HS256"})+"."+u(b);
s.end(JSON.stringify({access_token:h+"."+c.createHmac("sha256",k).update(h).digest("base64url"),issued_token_type:process.env.A,token_type:"Bearer"}))})})}).listen(5200)' &
sleep 2
x() { curl -s localhost:5200/token -u pedidos-teste:$SP -d grant_type=urn:ietf:params:oauth:grant-type:token-exchange -d subject_token=$T -d subject_token_type=$A -d audience=pagamentos "$@" | node -e "j=JSON.parse(require('fs').readFileSync(0));console.log(j.error?JSON.stringify(j):Buffer.from(j.access_token.split('.')[1],'base64url')+'')"; }
# 3. Sem actor token: impersonificação (só o sub). 4. Com o de pedidos-teste: delegação (o sub e o act)
echo; echo "== 3. Sem actor token: impersonificação (só o sub). 4. Com o de pedidos-teste: delegação (o sub e o act)"
x; x -d actor_token=$TA -d actor_token_type=$A
# 5. Um texto qualquer no actor token, e o de outro client: erro
echo; echo "== 5. Um texto qualquer no actor token, e o de outro client: erro"
x -d actor_token=xyz -d actor_token_type=$A; x -d actor_token=$T -d actor_token_type=$A
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$P -r curso; $K delete clients/$Q -r curso
