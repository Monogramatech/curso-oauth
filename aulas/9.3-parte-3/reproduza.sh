#!/usr/bin/env bash
# Aula 9.3, Parte 3: Rastreabilidade: txn, logs de troca e auditoria.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.3-parte-3/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect; A=urn:ietf:params:oauth:token-type:access_token
# 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)
echo; echo "== 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)"
c() { $K get clients/$($K create clients -r curso -s clientId=$1 -s serviceAccountsEnabled=true -i)/client-secret -r curso --fields value --format csv --noquotes; }
SP=$(c pedidos-teste); SG=$(c pagamentos-teste); SQ=$(c pessoa-teste); v() { sed 's/.*"access_token":"//;s/".*//'; }
t() { curl -s $I/token -u $1 -d grant_type=client_credentials | v; }; T=$(t pessoa-teste:$SQ); TP=$(t pedidos-teste:$SP); TG=$(t pagamentos-teste:$SG)
# 2. Servidor de troca mínimo (5200): txn criado na 1ª troca e copiado; até 3 atores; uma linha de registro por troca
echo; echo "== 2. Servidor de troca mínimo (5200): txn criado na 1ª troca e copiado; até 3 atores; uma linha de registro por troca"
I=$I A=$A node -e 'require("dns").setDefaultResultOrder("ipv4first");var c=require("crypto"),k=c.randomBytes(32);function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function h(x){return c.createHmac("sha256",k).update(x).digest("base64url")}
function q(t,a){var p=String(t).split(".");if(p[2]&&p[2]==h(p[0]+"."+p[1]))return Promise.resolve(Object.assign(JSON.parse(Buffer.from(p[1],"base64url")),{active:true}));
return fetch(process.env.I+"/token/introspect",{method:"POST",headers:{authorization:a},body:new URLSearchParams({token:t})}).then(function(r){return r.json()})}
function n(a){return a?[a.client_id].concat(n(a.act)):[]}
require("http").createServer(function(r,s){var d="";r.on("data",function(x){d+=x});r.on("end",function(){var p=new URLSearchParams(d),a=r.headers.authorization;
Promise.all([q(p.get("subject_token"),a),q(p.get("actor_token"),a)]).then(function(v){var e=(v[0].active&&v[1].active)?0:"invalid_request";
var b={sub:v[0].sub,aud:p.get("audience"),txn:v[0].txn||c.randomBytes(6).toString("base64url"),act:{client_id:v[1].client_id}};if(v[0].act)b.act.act=v[0].act;
var l=n(b.act);if(e==0&&Math.max(0,l.length-3))e="invalid_request";console.log("registro:",b.txn,l.join(","),e||"emitida");
if(e){s.writeHead(400);return s.end(JSON.stringify({error:e}))}var j=u({alg:"HS256"})+"."+u(b);
s.end(JSON.stringify({access_token:j+"."+h(j),issued_token_type:process.env.A,token_type:"Bearer"}))})})}).listen(5200)' &
sleep 2
x() { curl -s localhost:5200/token -u $1 -d grant_type=urn:ietf:params:oauth:grant-type:token-exchange -d subject_token=$2 -d subject_token_type=$A -d actor_token=$3 -d actor_token_type=$A -d audience=$4 $5; echo; }
# 3. O txn=forjado do parâmetro fica de fora; o 3º ator passa; o 4º, em círculo, é recusado
echo; echo "== 3. O txn=forjado do parâmetro fica de fora; o 3º ator passa; o 4º, em círculo, é recusado"
T1=$(x pedidos-teste:$SP $T $TP pagamentos-teste | v); T2=$(x pagamentos-teste:$SG $T1 $TG pedidos-teste "-d txn=forjado" | v)
T3=$(x pedidos-teste:$SP $T2 $TP pagamentos-teste | v); x pagamentos-teste:$SG $T3 $TG pedidos-teste
# Desfaz
echo; echo "== Desfaz"
kill %1; for n in pedidos-teste pagamentos-teste pessoa-teste; do $K delete clients/$($K get clients -r curso -q clientId=$n --fields id --format csv --noquotes) -r curso; done
