#!/usr/bin/env bash
# Aula 10.2, Parte 1: Claims do Entra (oid, tid, grupos, papéis) e o fluxo On-Behalf-Of.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
# 1. O Entra de verdade: o emissor com {tenantid}
echo; echo "== 1. O Entra de verdade: o emissor com {tenantid}"
curl -s https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration | node -e 'var j=JSON.parse(require("fs").readFileSync(0));console.log(j.issuer,j.subject_types_supported)'
# 2. Um emissor mínimo do curso no formato do Entra (porta 5790; não é o Entra), com o on-behalf-of e a regra do aud
echo; echo "== 2. Um emissor mínimo do curso no formato do Entra (porta 5790; não é o Entra), com o on-behalf-of e a regra do aud"
node -e 'var c=require("crypto"),k=c.generateKeyPairSync("rsa",{modulusLength:2048}),R={"api-pedidos":["Pedidos.Gerente"],"api-estoque":["Estoque.Consulta"]};
function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function tk(aud,azp,scp){var e=u({alg:"RS256"})+"."+u({aud:aud,iss:"http://127.0.0.1:5790/tid-da-loja/v2.0",azp:azp,oid:"oid-da-bia",tid:"tid-da-loja",scp:scp,roles:R[aud],ver:"2.0"});return e+"."+c.sign("sha256",Buffer.from(e),k.privateKey).toString("base64url")}
require("http").createServer(function(q,s){var d="";q.on("data",function(x){d+=x});q.on("end",function(){
if(q.url=="/login")return s.end(tk("api-pedidos","portal","Pedidos.Read"));
var p=Object.fromEntries(new URLSearchParams(d)),t=String(p.assertion).split("."),a=JSON.parse(Buffer.from(t[1]||"e30","base64url"));
if(p.requested_token_use=="on_behalf_of"&&p.client_secret=="segredo-de-teste"&&c.verify("sha256",Buffer.from(t[0]+"."+t[1]),k.publicKey,Buffer.from(t[2]||"","base64url")));else{s.writeHead(401);return s.end(JSON.stringify({error:"invalid_client"}))}
if(a.aud==p.client_id)return s.end(JSON.stringify({access_token:tk("api-estoque",p.client_id,"Estoque.Read")}));
s.writeHead(400);s.end(JSON.stringify({error:"invalid_grant",error_description:"assertion emitida para outro app (aud "+a.aud+")"}))})}).listen(5790,"127.0.0.1")' &
sleep 2
p() { node -e "var j=JSON.parse(require('fs').readFileSync(0));console.log(j.error?JSON.stringify(j):Buffer.from(j.access_token.split('.')[1],'base64url')+'')"; }
obo() { curl -s 127.0.0.1:5790/token -d grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer -d requested_token_use=on_behalf_of -d client_id=api-pedidos -d client_secret=segredo-de-teste -d assertion=$1 -d scope=api://api-estoque/Estoque.Read; }
# 3. O token da Bia (login simulado) e o on-behalf-of da API de pedidos
echo; echo "== 3. O token da Bia (login simulado) e o on-behalf-of da API de pedidos"
TA=$(curl -s 127.0.0.1:5790/login); R=$(obo $TA); echo $R | p
# 4. Exercício 2: o token do estoque apresentado pela API de pedidos
echo; echo "== 4. Exercício 2: o token do estoque apresentado pela API de pedidos"
obo $(echo $R | sed 's/.*"access_token":"//;s/".*//'); echo
kill %1
