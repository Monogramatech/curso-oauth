#!/usr/bin/env bash
# Aula 11.2, Parte 2: Aprovação humana: CIBA e step-up.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/11.2-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),K=C.randomBytes(32),P={};function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}
function g(x){return C.createHmac("sha256",K).update(x).digest("base64url")}function tk(c){var x=b(c);return x+"."+g(x)}function ag(){return Date.now()/1e3|0}
function ok(t){var x=String(t).split(".");try{if(g(x[0])==x[1])return JSON.parse(Buffer.from(x[0],"base64url"))}catch(e){}return 0}
function q(s,c,o,w){s.writeHead(c,w?{"WWW-Authenticate":w}:{});s.end(JSON.stringify(o)+"\n")}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var u=new URL(r.url,"http://x"),a=u.pathname,p=new URLSearchParams(t),c,e;
if(a=="/login")return q(s,200,{t:tk({sub:"bia",azp:"assistente",auth_time:ag()-20})});
if(a=="/ciba"){e=C.randomBytes(8).toString("hex");P[e]={ult:0};return q(s,200,{auth_req_id:e,expires_in:20,interval:2})}
if(a=="/celular"){P[p.get("id")].st=p.get("status");return q(s,200,{celular:p.get("status")})}
if(a=="/token"){c=P[p.get("auth_req_id")];if(c)0;else return q(s,400,{error:"invalid_grant"});
if(c.st=="SUCCEED"){delete P[p.get("auth_req_id")];return q(s,200,{t:tk({sub:"bia",azp:"assistente",auth_time:ag()})})}if(c.st=="UNAUTHORIZED")return q(s,400,{error:"access_denied"});
e=ag()-c.ult;c.ult=ag();return q(s,400,{error:Math.max(0,2-e)?"slow_down":"authorization_pending"})}
c=ok(String(r.headers.authorization).slice(7));if(c)0;else return q(s,401,{error:"invalid_token"});e=Number(u.searchParams.get("valor"));
if(Math.max(0,e-100)&&Math.max(0,ag()-c.auth_time-15))return q(s,401,{error:"insufficient_user_authentication"},"Bearer error=\"insufficient_user_authentication\", max_age=\"15\"");
q(s,201,{estorno:"EST-"+u.searchParams.get("pedido"),valor:e})})}).listen(5522,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5522; v() { sed 's/.*"t":"//;s/".*//'; }; id() { sed 's/.*"auth_req_id":"//;s/".*//'; }; G=urn:openid:params:grant-type:ciba
# 1. Token do dia a dia (há 20 s): o estorno de 80 passa; o de 990 leva 401 (RFC 9470)
echo; echo "== 1. Token do dia a dia (há 20 s): o estorno de 80 passa; o de 990 leva 401 (RFC 9470)"
T=$(curl -s $S/login | v); curl -s -X POST "$S/estornos?pedido=1033&valor=80" -H "Authorization: Bearer $T"
curl -s -i -X POST "$S/estornos?pedido=1042&valor=990" -H "Authorization: Bearer $T" | grep -i -E "^www-auth|^\{"
# 2. Pedido de CIBA: volta o identificador
echo; echo "== 2. Pedido de CIBA: volta o identificador"
R=$(curl -s $S/ciba -d "login_hint=bia&binding_message=ESTORNO-1042-990" | id)
# 3. Consulta: pendente; de novo, rápido demais
echo; echo "== 3. Consulta: pendente; de novo, rápido demais"
curl -s $S/token -d "grant_type=$G&auth_req_id=$R"; curl -s $S/token -d "grant_type=$G&auth_req_id=$R"
# 4. No papel da Bia, confirme; o token sai, e o estorno de 990 passa
echo; echo "== 4. No papel da Bia, confirme; o token sai, e o estorno de 990 passa"
curl -s $S/celular -d "id=$R&status=SUCCEED"; A=$(curl -s $S/token -d "grant_type=$G&auth_req_id=$R" | v)
curl -s -X POST "$S/estornos?pedido=1042&valor=990" -H "Authorization: Bearer $A"
# 5. Outro estorno, a Bia nega: acesso negado
echo; echo "== 5. Outro estorno, a Bia nega: acesso negado"
R=$(curl -s $S/ciba -d "login_hint=bia&binding_message=ESTORNO-1061-990" | id); curl -s $S/celular -d "id=$R&status=UNAUTHORIZED"; curl -s $S/token -d "grant_type=$G&auth_req_id=$R"
kill %1
