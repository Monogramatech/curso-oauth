#!/usr/bin/env bash
# Aula 9.3, Parte 2: Downscoping por salto e permissão efetiva = usuário ∩ ator.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/9.3-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso/protocol/openid-connect; A=urn:ietf:params:oauth:token-type:access_token
# 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)
echo; echo "== 1. pedidos-teste e pagamentos-teste (os saltos) e pessoa-teste (a pessoa)"
c() { $K get clients/$($K create clients -r curso -s clientId=$1 -s serviceAccountsEnabled=true -i)/client-secret -r curso --fields value --format csv --noquotes; }
SP=$(c pedidos-teste); SG=$(c pagamentos-teste); SQ=$(c pessoa-teste); v() { sed 's/.*"access_token":"//;s/".*//'; }
T=$(curl -s $I/token -u pessoa-teste:$SQ -d grant_type=client_credentials | v)
# 2. Servidor de troca mínimo (5200): escopo e exp nunca além do token recebido
echo; echo "== 2. Servidor de troca mínimo (5200): escopo e exp nunca além do token recebido"
I=$I A=$A node -e 'require("dns").setDefaultResultOrder("ipv4first");var c=require("crypto"),k=c.randomBytes(32);function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function h(x){return c.createHmac("sha256",k).update(x).digest("base64url")}
function q(t,a){var p=String(t).split(".");if(p[2]&&p[2]==h(p[0]+"."+p[1]))return Promise.resolve(Object.assign(JSON.parse(Buffer.from(p[1],"base64url")),{active:true}));
return fetch(process.env.I+"/token/introspect",{method:"POST",headers:{authorization:a},body:new URLSearchParams({token:t})}).then(function(r){return r.json()})}
require("http").createServer(function(r,s){var d="";r.on("data",function(x){d+=x});r.on("end",function(){var p=new URLSearchParams(d);q(p.get("subject_token"),r.headers.authorization).then(function(v){
var m=String(v.scope).split(" "),w=p.get("scope")?p.get("scope").split(" "):m,f=w.filter(function(x){return m.indexOf(x)==-1}),e=v.active?(f.length?"invalid_scope":0):"invalid_request";
if(e){s.writeHead(400);return s.end(JSON.stringify({error:e,error_description:f.join(" ")}))}
var t=Date.now()/1e3|0,b={sub:v.sub,aud:p.get("audience"),scope:w.join(" "),exp:Math.min(v.exp,t+60)},j=u({alg:"HS256"})+"."+u(b);
s.end(JSON.stringify({access_token:j+"."+h(j),issued_token_type:process.env.A,token_type:"Bearer",expires_in:b.exp-t,scope:b.scope}))})})}).listen(5200)' &
sleep 2
x() { curl -s localhost:5200/token -u $1 -d grant_type=urn:ietf:params:oauth:grant-type:token-exchange -d subject_token=$2 -d subject_token_type=$A -d audience=$3 -d "scope=$4"; echo; }
# 3. Salto 1: escopo fora do token recebido dá 400; só email passa, com 60 s
echo; echo "== 3. Salto 1: escopo fora do token recebido dá 400; só email passa, com 60 s"
x pedidos-teste:$SP $T pagamentos "email relatorios:ler"; R=$(x pedidos-teste:$SP $T pagamentos email); echo $R; T1=$(echo $R | v)
# 4. Salto 2, 5 s depois: profile ficou para trás (400); sem escopo, email, com o exp do salto 1
echo; echo "== 4. Salto 2, 5 s depois: profile ficou para trás (400); sem escopo, email, com o exp do salto 1"
sleep 5; x pagamentos-teste:$SG $T1 notas-fiscais profile; x pagamentos-teste:$SG $T1 notas-fiscais ""
# Desfaz
echo; echo "== Desfaz"
kill %1; for n in pedidos-teste pagamentos-teste pessoa-teste; do $K delete clients/$($K get clients -r curso -q clientId=$n --fields id --format csv --noquotes) -r curso; done
