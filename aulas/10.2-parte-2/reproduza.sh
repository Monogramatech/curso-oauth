#!/usr/bin/env bash
# Aula 10.2, Parte 2: Os limites do OBO: por que ele não atravessa para outro domínio.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
# 1. O Entra real, app inventado (só erros): o controle e a troca da RFC 8693
echo; echo "== 1. O Entra real, app inventado (só erros): o controle e a troca da RFC 8693"
q() { node -e 'console.log(JSON.parse(require("fs").readFileSync(0)).error_description.split(" Trace")[0])'; }
U=https://login.microsoftonline.com/organizations/oauth2/v2.0/token; G=9265eea0-e504-4030-8baf-eae1683c013a; TE=urn:ietf:params:oauth:grant-type:token-exchange
curl -s $U -d grant_type=nao-existe -d client_id=$G | q
curl -s $U -d grant_type=$TE -d client_id=$G -d subject_token=abc -d subject_token_type=x | q
# 2. Emissor mínimo do curso (5790, não é o Entra): o estoque exige o segundo fator
echo; echo "== 2. Emissor mínimo do curso (5790, não é o Entra): o estoque exige o segundo fator"
node -e 'var c=require("crypto"),k=c.generateKeyPairSync("rsa",{modulusLength:2048}),P="mfa-estoque";
function u(o){return Buffer.from(JSON.stringify(o)).toString("base64url")}
function tk(aud,azp,amr){var e=u({alg:"RS256"})+"."+u({aud:aud,azp:azp,amr:amr,oid:"oid-da-bia"});return e+"."+c.sign("sha256",Buffer.from(e),k.privateKey).toString("base64url")}
require("http").createServer(function(q,s){var d="";q.on("data",function(x){d+=x});q.on("end",function(){
if(q.url.indexOf("/login")==0)return s.end(tk("api-pedidos","portal",decodeURIComponent(q.url).indexOf(P)+1?["pwd","mfa"]:["pwd"]));
var p=Object.fromEntries(new URLSearchParams(d)),t=String(p.assertion).split("."),a=JSON.parse(Buffer.from(t[1]||"e30","base64url"));
if(p.client_secret=="teste"&&a.aud==p.client_id&&c.verify("sha256",Buffer.from(t[0]+"."+t[1]),k.publicKey,Buffer.from(t[2]||"","base64url")));else{s.writeHead(400);return s.end("{}")}
if(a.amr.indexOf("mfa")+1)return s.end(JSON.stringify({access_token:tk("api-estoque",p.client_id,a.amr)}));
s.writeHead(400);s.end(JSON.stringify({error:"interaction_required",claims:JSON.stringify({access_token:{polids:{essential:true,values:[P]}}})}))})}).listen(5790,"127.0.0.1")' &
sleep 2
p() { node -e "var j=JSON.parse(require('fs').readFileSync(0));console.log(j.error?JSON.stringify(j):Buffer.from(j.access_token.split('.')[1],'base64url')+'')"; }
obo() { curl -s 127.0.0.1:5790/token -d grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer -d requested_token_use=on_behalf_of -d client_id=api-pedidos -d client_secret=teste -d assertion=$1 -d scope=api://api-estoque/Estoque.Read; }
# 3. Login só com senha: a troca devolve o desafio
echo; echo "== 3. Login só com senha: a troca devolve o desafio"
TA=$(curl -s 127.0.0.1:5790/login); obo $TA | p
# 4. Login de novo com o desafio em claims: a troca passa
echo; echo "== 4. Login de novo com o desafio em claims: a troca passa"
TA=$(curl -s -G 127.0.0.1:5790/login --data-urlencode 'claims={"access_token":{"polids":{"values":["mfa-estoque"]}}}'); obo $TA | p
kill %1
