#!/usr/bin/env bash
# Aula 12.6, Parte 1: Device code na CLI e na TV: o golpe do código e as defesas.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.6-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var http=require("http"),D={},U={},R={},ESC=["pedidos:ler","offline_access"];
function id(){return Math.random().toString(36).slice(2,6).toUpperCase()}
http.createServer(function(q,s){var u=new URL(q.url,"http://x"),p=function(k){return u.searchParams.get(k)||""},f=u.pathname,d=D[p("device_code")||U[p("user_code")]],r;
function j(st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
if(f=="/device"){if(p("client")=="pedidos-cli")0;else return j(400,{error:"unauthorized_client"});
var dc="d"+id()+id(),uc=id()+"-"+id();D[dc]={sc:p("scope").split(" ").filter(function(x){return ESC.indexOf(x)+1})};U[uc]=dc;
return j(200,{device_code:dc,user_code:uc,verification_uri_complete:"http://127.0.0.1:5850/verificar?user_code="+uc,expires_in:600,interval:5})}
if(f=="/verificar"){d.quem="bia";return j(200,{tela:"Grant Access to CLI de Pedidos da Loja",itens:d.sc,mostra_o_codigo:false})}
if(f=="/token"){if(d.quem)0;else return j(400,{error:"authorization_pending"});var off=d.sc.indexOf("offline_access")+1;r="r"+id()+id();R[r]={off:off,vivo:1};
return j(200,{pessoa:d.quem,azp:"pedidos-cli",scope:d.sc.join(" "),refresh:r,refresh_typ:off?"Offline":"Refresh"})}
if(f=="/sair"){for(r in R)if(R[r].off)0;else R[r].vivo=0;return j(200,{saiu:"bia"})}
if(f=="/remover"){for(r in R)R[r].vivo=0;return j(200,{removido:"pedidos-cli"})}
if(f=="/escopo-minimo"){ESC=["pedidos:ler"];for(r in R)if(R[r].off)R[r].vivo=0;return j(200,{escopos:ESC})}
var x=R[p("r")];return x&&x.vivo?j(200,{renovou:"bia"}):j(400,{error:"invalid_grant"})
}).listen(5850,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5850; e(){ sed "s/.*\"$1\":\"\([^\"]*\)\".*/\1/" $2; }; c(){ curl -s "$S/device?client=pedidos-cli&scope=$1" | tee /tmp/d; }
# 1. O atacante pede um código com o client_id público da CLI; antes da aprovação, a consulta espera
echo; echo "== 1. O atacante pede um código com o client_id público da CLI; antes da aprovação, a consulta espera"
c openid+pedidos:ler+offline_access; curl -s "$S/token?device_code=$(e device_code /tmp/d)"
# 2. A Bia abre o link e aprova (a tela não mostra o código); o token offline vai para o atacante
echo; echo "== 2. A Bia abre o link e aprova (a tela não mostra o código); o token offline vai para o atacante"
curl -s "$S/verificar?user_code=$(e user_code /tmp/d)"; curl -s "$S/token?device_code=$(e device_code /tmp/d)" | tee /tmp/t1
# 3. A Bia sai da conta: o token offline do atacante continua renovando
echo; echo "== 3. A Bia sai da conta: o token offline do atacante continua renovando"
curl -s "$S/sair"; curl -s "$S/renovar?r=$(e refresh /tmp/t1)"
# 4. A Bia remove o acesso da CLI na conta: o token offline do golpe cai
echo; echo "== 4. A Bia remove o acesso da CLI na conta: o token offline do golpe cai"
curl -s "$S/remover"; curl -s "$S/renovar?r=$(e refresh /tmp/t1)"
# 5. Defesas: o site sem device code; a CLI sem offline_access, e a saída da Bia corta o token novo
echo; echo "== 5. Defesas: o site sem device code; a CLI sem offline_access, e a saída da Bia corta o token novo"
curl -s "$S/device?client=loja-web"; curl -s "$S/escopo-minimo"; c openid+pedidos:ler+offline_access
curl -s "$S/verificar?user_code=$(e user_code /tmp/d)"; curl -s "$S/token?device_code=$(e device_code /tmp/d)" | tee /tmp/t2; curl -s "$S/sair"; curl -s "$S/renovar?r=$(e refresh /tmp/t2)"
kill %1
