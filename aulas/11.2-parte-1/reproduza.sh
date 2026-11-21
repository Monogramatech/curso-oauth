#!/usr/bin/env bash
# Aula 11.2, Parte 1: O token expira no meio da tarefa.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/11.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),K=C.randomBytes(32),vivo=1;function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}
function g(x){return C.createHmac("sha256",K).update(x).digest("base64url")}function tk(c){var x=b(c);return x+"."+g(x)}
function ok(t){var x=String(t).split(".");try{if(g(x[0])==x[1])return JSON.parse(Buffer.from(x[0],"base64url"))}catch(e){}return 0}
function ag(){return Date.now()/1e3|0}function va(c){return c&&Math.max(0,c.exp-ag())}function q(s,c,o){s.writeHead(c);s.end(JSON.stringify(o)+"\n")}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var p=new URLSearchParams(t),a=r.url,c,n;
if(a=="/login"){vivo=1;return q(s,200,{t:tk({sub:"bia",exp:ag()+5}),rt:tk({cli:"portal"})})}
if(a=="/troca"){c=ok(p.get("s"));n=Number(p.get("ttl"))||5;if(va(c)&&vivo)return q(s,200,{t:tk({sub:c.sub,azp:"assistente",exp:ag()+n}),expires_in:n});return q(s,400,{error:"invalid_request",error_description:"Invalid token"})}
if(a=="/refresh"){c=ok(p.get("rt"));if(c.cli==p.get("cli"))0;else return q(s,400,{error:"invalid_grant",error_description:"client mismatch"});if(vivo)return q(s,200,{t:tk({sub:"bia",exp:ag()+5})});return q(s,400,{error:"invalid_grant",error_description:"Session not active"})}
if(a=="/logout"){vivo=0;return q(s,200,{logout:"feito"})}
if(a=="/introspect")return q(s,200,{active:Boolean(va(ok(p.get("t")))&&vivo)});
c=ok(String(r.headers.authorization).slice(7));if(va(c))return q(s,201,{cobranca:"COB-1042",faltam_s:c.exp-ag()});q(s,401,{error:"invalid_token"})})}).listen(5491,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5491; v() { sed 's/.*"t":"//;s/".*//'; }; L=$(curl -s $S/login); T=$(echo $L | v); R=$(echo $L | sed 's/.*"rt":"//;s/".*//')
# 1. No começo, o token de tarefa (60 s, uma troca só); depois, espera o token da Bia vencer
echo; echo "== 1. No começo, o token de tarefa (60 s, uma troca só); depois, espera o token da Bia vencer"
X=$(curl -s $S/troca -d "s=$T&ttl=60" | v); sleep 6
# 2. A troca com o token da Bia vencido: 400 invalid_request
echo; echo "== 2. A troca com o token da Bia vencido: 400 invalid_request"
curl -s $S/troca -d "s=$T"
# 3. O refresh token do portal na mão do assistente: 400; o portal renova, e a troca passa
echo; echo "== 3. O refresh token do portal na mão do assistente: 400; o portal renova, e a troca passa"
curl -s $S/refresh -d "rt=$R&cli=assistente"; N=$(curl -s $S/refresh -d "rt=$R&cli=portal" | v); curl -s $S/troca -d "s=$N" | sed 's/"t":"[^"]*",//'
# 4. O token de tarefa paga sem renovar nada (201)
echo; echo "== 4. O token de tarefa paga sem renovar nada (201)"
curl -s -X POST $S/pagar -H "Authorization: Bearer $X"
# 5. A Bia sai: o portal não renova mais; o token de tarefa ainda paga, e só a introspecção diz que ele está inativo
echo; echo "== 5. A Bia sai: o portal não renova mais; o token de tarefa ainda paga, e só a introspecção diz que ele está inativo"
curl -s -X POST $S/logout; curl -s $S/refresh -d "rt=$R&cli=portal"; curl -s -X POST $S/pagar -H "Authorization: Bearer $X"; curl -s $S/introspect -d "t=$X"
kill %1
