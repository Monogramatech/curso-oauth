#!/usr/bin/env bash
# Aula 10.4, Parte 2: Transaction Tokens.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.4-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
# 1. Serviço de tokens (5450); pedidos (5451) chama pagamentos (5452); entregas (5453) é de outro domínio
echo; echo "== 1. Serviço de tokens (5450); pedidos (5451) chama pagamentos (5452); entregas (5453) é de outro domínio"
node -e 'var C=require("crypto"),h=require("http"),k=C.generateKeyPairSync("ec",{namedCurve:"P-256"}),D="loja.interno",T="urn:ietf:params:oauth:token-type:txn_token";
function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}function q(s,c,o){s.writeHead(c,{"Content-Type":"application/json"});s.end(JSON.stringify(o))}
function l(r,f){var t="";r.on("data",function(x){t+=x});r.on("end",function(){f(t)})}
h.createServer(function(r,s){l(r,function(t){var p=new URLSearchParams(t),n=Date.now()/1e3|0;
if(r.headers.authorization=="Basic "+Buffer.from("gateway:segredo-de-teste").toString("base64"))0;else return q(s,401,{error:"invalid_client"});
if(p.get("requested_token_type")==T&&p.get("audience")==D)0;else return q(s,400,{error:"invalid_request"});
var e=b({typ:"txntoken+jwt",alg:"ES256"})+"."+b({iat:n,aud:D,exp:n+60,txn:C.randomUUID(),sub:JSON.parse(p.get("subject_token")).sub,scope:p.get("scope"),tctx:JSON.parse(p.get("request_details")),req_wl:"gateway"});
q(s,200,{token_type:"N_A",issued_token_type:T,access_token:e+"."+C.sign("sha256",Buffer.from(e),{key:k.privateKey,dsaEncoding:"ieee-p1363"}).toString("base64url")})})}).listen(5450);
function sv(o,m,d,y){h.createServer(function(r,s){l(r,function(t){var x=String(r.headers["txn-token"]).split("."),j=JSON.parse(t||"{}"),c;
try{c=JSON.parse(Buffer.from(x[1],"base64url"))}catch(e){return q(s,401,{servico:m,motivo:"sem token de transação"})}if(c.aud==d)0;else return q(s,401,{servico:m,motivo:"audiência "+c.aud});
if(C.verify("sha256",Buffer.from(x[0]+"."+x[1]),{key:k.publicKey,dsaEncoding:"ieee-p1363"},Buffer.from(x[2],"base64url")))0;else return q(s,401,{servico:m,motivo:"assinatura"});
if(Math.max(0,(Date.now()/1e3|0)-c.exp+1))return q(s,401,{servico:m,motivo:"vencido"});
if(j.pedido==c.tctx.pedido&&j.valor==c.tctx.valor)0;else return q(s,403,{servico:m,motivo:"valor "+j.valor+", mas o contexto diz "+c.tctx.valor});
if(y)fetch(y,{method:"POST",headers:{"Content-Type":"application/json","Txn-Token":r.headers["txn-token"]},body:t}).then(function(z){return z.json()}).then(function(z){q(s,200,{servico:m,depois:z})});
else q(s,200,{servico:m,ok:1,txn:c.txn})})}).listen(o)}sv(5451,"pedidos",D,"http://127.0.0.1:5452/cobrancas");sv(5452,"pagamentos",D);sv(5453,"entregas","transportadora.interno")' &
sleep 2
U=urn:ietf:params:oauth
# 2. O gateway pede o token de transação, com a intenção e os detalhes
echo; echo "== 2. O gateway pede o token de transação, com a intenção e os detalhes"
X=$(curl -s localhost:5450/token -u gateway:segredo-de-teste -d grant_type=$U:grant-type:token-exchange -d requested_token_type=$U:token-type:txn_token -d audience=loja.interno -d scope=pagar-pedido -d subject_token_type=$U:token-type:unsigned_json -d 'subject_token={"sub":"bia"}' -d 'request_details={"pedido":1042,"valor":"99,00"}' | sed 's/.*"access_token":"//;s/".*//')
c() { curl -s localhost:$1 -H "Txn-Token: $X" -d "$2"; echo; }
# 3. A compra passa; 990 em pagamentos cai (403); entregas, de outro domínio, recusa (401)
echo; echo "== 3. A compra passa; 990 em pagamentos cai (403); entregas, de outro domínio, recusa (401)"
c 5451/pagar '{"pedido":1042,"valor":"99,00"}'; c 5452/cobrancas '{"pedido":1042,"valor":"990,00"}'; c 5453/entregas '{"pedido":1042,"valor":"99,00"}'
kill %1
