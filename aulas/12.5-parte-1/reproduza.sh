#!/usr/bin/env bash
# Aula 12.5, Parte 1: Apps de terceiros com OAuth: registro, consentimento e revogação.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.5-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var http=require("http"),C={},OK={},R={},pol=0,n=0,LIB=["pedidos:ler","enderecos:ler"];
function rt(app,quem){var r="r"+Math.random().toString(36).slice(2);R[r]={app:app,quem:quem,vivo:1};return{refresh:r}}
http.createServer(function(q,s){var u=new URL(q.url,"http://x"),p=function(k){return u.searchParams.get(k)},app=p("app"),quem=p("quem"),c=C[app],f=u.pathname;
function j(st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
if(f=="/politica"){pol=1;return j(200,{consentimento:"obrigatorio nos registros novos"})}
if(f=="/registro"){if(p("scope").split(" ").every(function(x){return LIB.indexOf(x)+1}))0;else return j(403,{error:"insufficient_scope"});
var id="app-"+(++n);C[id]={nome:p("nome"),scope:p("scope"),consent:pol,ligado:1};return j(201,{client_id:id,consentRequired:Boolean(pol)})}
if(f=="/entrar"){if(c.ligado)0;else return j(401,{erro:"Client disabled"});if(c.consent&&OK[app+quem]==undefined)return j(200,{tela:"consentimento",itens:c.scope});return j(200,rt(app,quem))}
if(f=="/consentir"){OK[app+quem]=1;return j(200,rt(app,quem))}
if(f=="/revogar"){var h=OK[app+quem]==1;delete OK[app+quem];if(h)for(var r in R)if(R[r].app==app&&R[r].quem==quem)R[r].vivo=0;return j(200,{revogado:quem,havia_consentimento:h})}
if(f=="/desligar"||f=="/ligar"){c.ligado=f=="/ligar";return j(200,{ligado:c.ligado})}
var x=R[p("r")];if(c.ligado)0;else return j(401,{error:"invalid_client"});return x&&x.vivo?j(200,{renovou:quem}):j(400,{error:"invalid_grant"})
}).listen(5840,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5840; e(){ sed 's/.*"\(r[a-z0-9]*\)".*/\1/' $1; }
# 1. Sem a política: escopo fora da lista leva 403; o Rastreio nasce sem pedir consentimento
echo; echo "== 1. Sem a política: escopo fora da lista leva 403; o Rastreio nasce sem pedir consentimento"
curl -s "$S/registro?nome=Rastreio&scope=pedidos:cancelar"; curl -s "$S/registro?nome=Rastreio&scope=pedidos:ler"
# 2. A Bia entra sem tela; ela revoga, e o app segue renovando (não havia consentimento)
echo; echo "== 2. A Bia entra sem tela; ela revoga, e o app segue renovando (não havia consentimento)"
curl -s "$S/entrar?app=app-1&quem=bia" | tee /tmp/b1; curl -s "$S/revogar?app=app-1&quem=bia"; curl -s "$S/renovar?app=app-1&quem=bia&r=$(e /tmp/b1)"
# 3. Com a política, o Etiqueta pede consentimento; a Bia e o Caio consentem
echo; echo "== 3. Com a política, o Etiqueta pede consentimento; a Bia e o Caio consentem"
curl -s "$S/politica"; curl -s "$S/registro?nome=Etiqueta&scope=pedidos:ler"; curl -s "$S/entrar?app=app-2&quem=bia"
curl -s "$S/consentir?app=app-2&quem=bia" | tee /tmp/b2; curl -s "$S/consentir?app=app-2&quem=caio" | tee /tmp/c2
# 4. A Bia revoga o Etiqueta: o refresh token dela cai, o do Caio segue
echo; echo "== 4. A Bia revoga o Etiqueta: o refresh token dela cai, o do Caio segue"
curl -s "$S/revogar?app=app-2&quem=bia"; curl -s "$S/renovar?app=app-2&quem=bia&r=$(e /tmp/b2)"; curl -s "$S/renovar?app=app-2&quem=caio&r=$(e /tmp/c2)"
# 5. A plataforma desliga o Etiqueta (401) e religa: o mesmo refresh token do Caio volta
echo; echo "== 5. A plataforma desliga o Etiqueta (401) e religa: o mesmo refresh token do Caio volta"
curl -s "$S/desligar?app=app-2"; curl -s "$S/renovar?app=app-2&quem=caio&r=$(e /tmp/c2)"; curl -s "$S/ligar?app=app-2"; curl -s "$S/renovar?app=app-2&quem=caio&r=$(e /tmp/c2)"
kill %1
