#!/usr/bin/env bash
# Aula 12.3, Parte 1: Refresh token no app de celular: o login que dura semanas.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),H=C.randomBytes(32),R={},F={},ag=Date.now;function sg(x){return C.createHmac("sha256",H).update(x).digest("base64url")}
function par(f){var r=C.randomBytes(9).toString("hex"),a=Buffer.from(JSON.stringify({sub:"bia",exp:ag()+2e3})).toString("base64url");R[r]={f:f};F[f].u=ag();return{tipo:F[f].off?"Offline":"Refresh",a:a+"."+sg(a),r:r}}
require("http").createServer(function(q,s){var b="";q.on("data",function(d){b+=d});q.on("end",function(){var p=new URLSearchParams(b),u=q.url,x=R[p.get("r")],f=x&&F[x.f];
function j(st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
if(u=="/entrar"){var i=C.randomBytes(6).toString("hex");F[i]={v:1,off:p.get("offline")=="1"};return j(200,par(i))}
if(u=="/pedidos"){var t=(q.headers.authorization||"").slice(7).split("."),c=sg(t[0])==t[1]&&JSON.parse(Buffer.from(t[0],"base64url"));return c&&Math.max(0,c.exp-ag())?j(200,{pedidos:[2041]}):j(401,{erro:"invalid_token"})}
if(f&&f.v)0;else return j(400,{erro:"invalid_grant: sessao derrubada"});
if(u=="/revogar"){f.v=0;return j(200,{revogado:1})}
if(x.usado){f.v=0;return j(400,{erro:"invalid_grant: reuso, a sessao caiu"})}
if(f.off||Math.max(0,ag()-f.u-4e3)==0)0;else{f.v=0;return j(400,{erro:"invalid_grant: sessao parada"})}
x.usado=1;j(200,par(x.f))})}).listen(5830,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5830; e(){ sed 's/.*"r":"\([0-9a-f]*\)".*/\1/' $1; }
APP='var S="http://127.0.0.1:5830",M=process.argv[1],n=0,em=0;
function post(p,d){return fetch(S+p,{method:"POST",body:new URLSearchParams(d)}).then(function(r){return r.json().then(function(j){j.st=r.status;return j})})}
function pede(c){n++;return post("/token",{r:c.r}).then(function(j){if(j.st-200)throw 0;c.r=j.r;c.a=j.a})}
function renova(c){if(M=="ingenua")return pede(c);if(em)return em;return em=pede(c).finally(function(){em=0})}
function api(c){return fetch(S+"/pedidos",{headers:{authorization:"Bearer "+c.a}}).then(function(r){return r.status})}
function chama(c){return api(c).then(function(st){return st-401?st:renova(c).then(function(){return api(c)})})}
post("/entrar",{offline:1}).then(function(c){setTimeout(function(){Promise.allSettled([chama(c),chama(c),chama(c)]).then(function(t){post("/token",{r:c.r}).then(function(j){
console.log(JSON.stringify({versao:M,renovacoes:n,telas:t.map(function(x){return x.value||"o login caiu"}),depois:j.st}))})})},3e3)})'
# 1. Comum x offline, parados 5 s
echo; echo "== 1. Comum x offline, parados 5 s"
curl -s -d offline=0 $S/entrar | tee /tmp/c1; curl -s -d offline=1 $S/entrar | tee /tmp/o1; sleep 5
curl -s -d r=$(e /tmp/c1) $S/token; curl -s -d r=$(e /tmp/o1) $S/token
# 2. Três telas com o token vencido: ingênua x certa
echo; echo "== 2. Três telas com o token vencido: ingênua x certa"
node -e "$APP" ingenua; node -e "$APP" certa
# 3. Resposta perdida: o app repete o token velho
echo; echo "== 3. Resposta perdida: o app repete o token velho"
curl -s -d offline=1 $S/entrar | tee /tmp/p1; curl -s -d r=$(e /tmp/p1) $S/token; curl -s -d r=$(e /tmp/p1) $S/token
# 4. O botão Sair revoga o token offline
echo; echo "== 4. O botão Sair revoga o token offline"
curl -s -d offline=1 $S/entrar | tee /tmp/s1; curl -s -d r=$(e /tmp/s1) $S/revogar; curl -s -d r=$(e /tmp/s1) $S/token
kill %1
