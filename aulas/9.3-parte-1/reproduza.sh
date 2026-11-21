#!/usr/bin/env bash
# Aula 9.3, Parte 1: act aninhado e may_act.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect; A=urn:ietf:params:oauth:token-type:access_token
# 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)
echo; echo "== 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)"
c() { $K get clients/$($K create clients -r curso -s clientId=$1 -s serviceAccountsEnabled=true -i)/client-secret -r curso --fields value --format csv --noquotes; }
SP=$(c pedidos-teste); SG=$(c pagamentos-teste); SQ=$(c pessoa-teste)
t() { curl -s $I/token -u $1 -d grant_type=client_credentials | sed 's/.*"access_token":"//;s/".*//'; }
T=$(t pessoa-teste:$SQ); TP=$(t pedidos-teste:$SP); TG=$(t pagamentos-teste:$SG)
# 2. Servidor de troca mínimo (porta 5200): aceita tokens do Keycloak e os dele, e aninha a act
echo; echo "== 2. Servidor de troca mínimo (porta 5200): aceita tokens do Keycloak e os dele, e aninha a act"
I=$I A=$A node -e 'require("dns").setDefaultResultOrder("ipv4first");var c=require("crypto"),k=c.randomBytes(32);function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function h(x){return c.createHmac("sha256",k).update(x).digest("base64url")}
function q(t,a){var p=t.split(".");if(p[2]&&p[2]==h(p[0]+"."+p[1]))return Promise.resolve(Object.assign(JSON.parse(Buffer.from(p[1],"base64url")),{active:true}));
return fetch(process.env.I+"/token/introspect",{method:"POST",headers:{authorization:a,"content-type":"application/x-www-form-urlencoded"},body:"token="+t}).then(function(r){return r.json()})}
require("http").createServer(function(r,s){var d="";r.on("data",function(x){d+=x});r.on("end",function(){var p=new URLSearchParams(d),a=r.headers.authorization,A=p.get("actor_token");
function e(m){s.writeHead(400);s.end(JSON.stringify({error:"invalid_request",error_description:m}))}Promise.all([q(p.get("subject_token"),a),A?q(A,a):{active:true}]).then(function(v){
if((v[0].active&&v[1].active)?0:1)return e("token invalido");
var b={iss:"http://localhost:5200",sub:v[0].sub,aud:p.get("audience"),exp:(Date.now()/1e3|0)+300};if(A)b.act={sub:v[1].sub,client_id:v[1].client_id};if(A&&v[0].act)b.act.act=v[0].act;var j=u({alg:"HS256"})+"."+u(b);
s.end(JSON.stringify({access_token:j+"."+h(j),issued_token_type:process.env.A,token_type:"Bearer"}))})})}).listen(5200)' &
sleep 2
x() { curl -s localhost:5200/token -u $1 -d grant_type=urn:ietf:params:oauth:grant-type:token-exchange -d subject_token=$2 -d subject_token_type=$A -d actor_token=$3 -d actor_token_type=$A -d audience=$4; }
p() { node -e "j=JSON.parse(require('fs').readFileSync(0));console.log(j.error?JSON.stringify(j):Buffer.from(j.access_token.split('.')[1],'base64url')+'')"; }
# 3. Salto 1, de pedidos-teste; salto 2, de pagamentos-teste (a act do salto 1 vai dentro)
echo; echo "== 3. Salto 1, de pedidos-teste; salto 2, de pagamentos-teste (a act do salto 1 vai dentro)"
R=$(x pedidos-teste:$SP $T $TP pagamentos-teste); echo $R | p; T1=$(echo $R | sed 's/.*"access_token":"//;s/".*//')
x pagamentos-teste:$SG $T1 $TG notas-fiscais | p
# Desfaz
echo; echo "== Desfaz"
kill %1; for n in pedidos-teste pagamentos-teste pessoa-teste; do $K delete clients/$($K get clients -r curso -q clientId=$n --fields id --format csv --noquotes) -r curso; done
