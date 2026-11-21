#!/usr/bin/env bash
# Aula 12.8, Parte 1: Agente de IA com ferramentas MCP: o token de cada salto.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.8-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var h=require("http"),c=require("crypto"),K=c.randomBytes(16),M="http://127.0.0.1:5870/mcp";
function sg(o){var b=Buffer.from(JSON.stringify(o)).toString("base64url");return b+"."+c.createHmac("sha256",K).update(b).digest("base64url")}
function le(t){try{var o=JSON.parse(Buffer.from(t.split(".")[0],"base64url"));if(sg(o)==t)return o}catch(e){}}
function api(t,f){if(t.aud.includes("api-pedidos"))0;else return{api:401,motivo:"audiencia"};var q=f=="listar"?"api-pedidos:ler":"api-pedidos:estornar";
if(t.scope.split(" ").includes(q))0;else return{api:403};var r={api:200,pessoa:t.pessoa,ator:t.act?t.act.client_id:null};if(f=="listar")r.pedidos=t.pessoa=="bia"?[4471,4472]:[];else r.estornado=4471;return r}
function troca(b,pede){if(b.may_act&&b.may_act.client_id==M)0;else return{troca:400};return api({pessoa:b.pessoa,aud:["api-pedidos"],scope:"api-pedidos:ler"+(pede?" api-pedidos:estornar":""),act:{client_id:M}},pede?"estornar":"listar")}
h.createServer(function(q,s){var u=new URL(q.url,"http://x"),g=function(k){return u.searchParams.get(k)},j=function(n,o){s.writeHead(n);s.end(JSON.stringify(o)+"\n")};
if(u.pathname=="/login"){var e=g("scope").split(" "),o={pessoa:"bia",aud:[M],scope:e.join(" ")},t=e.filter(function(x){return x.indexOf("pedidos:")==0});
if(e.includes("delegation")){o.may_act={client_id:M};t.push("Allow "+M+" to act on your behalf?")}return j(200,{tela:t,aud:o.aud,may_act:o.may_act||null,token:sg(o)})}
var b=le(g("token")),f=g("f"),v=g("v");if(b&&b.aud.includes(M))0;else return j(401,{error:"invalid_token"});
var w=f=="listar"?"pedidos:ler":"pedidos:estornar";if(v=="ingenua"||b.scope.split(" ").includes(w))0;else return j(403,{error:"insufficient_scope",scope:w});
if(v=="repasse")return j(200,api(b,f));if(v=="proprio")return j(200,api({pessoa:"service-account",aud:["api-pedidos"],scope:"api-pedidos:ler"},f));
j(200,troca(b,f=="estornar"))}).listen(5870,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5870; v(){ sed "s/.*\"$1\":\"\([^\"]*\)\".*/\1/" $2; }
# 1. O login com a delegação: o token vale só para o servidor MCP e traz may_act
echo; echo "== 1. O login com a delegação: o token vale só para o servidor MCP e traz may_act"
curl -s "$S/login?scope=pedidos:ler+delegation" | tee /tmp/b
# 2. O segundo salto, três jeitos: o repasse cai; o token do servidor perde a pessoa; a troca delegada leva a Bia e o ator
echo; echo "== 2. O segundo salto, três jeitos: o repasse cai; o token do servidor perde a pessoa; a troca delegada leva a Bia e o ator"
for x in repasse proprio troca; do curl -s "$S/mcp?f=listar&v=$x&token=$(v token /tmp/b)"; done
# 3. O estorno com o token de leitura: o servidor certo responde 403; o ingênuo pede o escopo na troca e estorna
echo; echo "== 3. O estorno com o token de leitura: o servidor certo responde 403; o ingênuo pede o escopo na troca e estorna"
for x in troca ingenua; do curl -s "$S/mcp?f=estornar&v=$x&token=$(v token /tmp/b)"; done
# 4. A união dos escopos: um login novo, e o estorno passa pelo caminho certo
echo; echo "== 4. A união dos escopos: um login novo, e o estorno passa pelo caminho certo"
curl -s "$S/login?scope=pedidos:ler+delegation+pedidos:estornar" | tee /tmp/u; curl -s "$S/mcp?f=estornar&v=troca&token=$(v token /tmp/u)"
kill %1
