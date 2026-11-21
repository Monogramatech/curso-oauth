#!/usr/bin/env bash
# Aula 12.7, Parte 2: Agente de IA com delegação no Keycloak: may_act e act.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.7-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var h=require("http"),c=require("crypto"),K=c.randomBytes(16),P=0,A="agente-estoque",E="api-estoque";
function sg(o){var b=Buffer.from(JSON.stringify(o)).toString("base64url");return b+"."+c.createHmac("sha256",K).update(b).digest("base64url")}
function le(t){try{var o=JSON.parse(Buffer.from(t.split(".")[0],"base64url"));if(sg(o)==t)return o}catch(e){}}
function bia(d,so){var o={pessoa:"bia",aud:so?[]:[E],exp:Date.now()/1000+300};if(d&&P){o.may_act={client_id:A};o.aud.push(A)}return o}
h.createServer(function(q,s){var u=new URL(q.url,"http://x"),p=u.pathname,g=function(k){return u.searchParams.get(k)},j=function(n,o){s.writeHead(n);s.end(JSON.stringify(o)+"\n")},f=function(m){j(400,{error_description:m})};
if(p=="/permissao"){P=+g("liga");return j(200,{delegate:P})}
if(p=="/login"){var so=g("registro")=="delega",o=bia(g("delegar")==A,so),t=so?[]:["Ler o saldo do estoque"];if(o.may_act)t.push("Allow "+A+" to act on your behalf?");return j(200,{tela:t,aud:o.aud,may_act:o.may_act||null,token:sg(o)})}
if(p=="/renova"){var r=le(g("token")),o=bia(Boolean(r.may_act),r.aud[0]==A);return j(200,{may_act:o.may_act||null,token:sg(o)})}
if(p=="/troca"){var x=le(g("subject")),a=g("ator");if(x)0;else return f("Invalid subject_token");
if(a){if(a==A)0;else return f("Invalid actor_token");if(x.may_act&&x.may_act.client_id==A)0;else return f("Invalid may_act claim in the subject_token");var o={pessoa:x.pessoa,act:{client_id:A},aud:[E],exp:x.exp};return j(200,{act:o.act,aud:o.aud,refresh_token:null,token:sg(o)})}
if(x.may_act||x.act)return f("Subject token with a delegation claim is not allowed for standard token exchange");return j(200,{pessoa:x.pessoa})}
var x=le(g("token"));if(x)0;else return j(401,{erro:"invalid_token"});if(x.aud.indexOf(E)+1)0;else return j(401,{erro:"audiencia"});j(200,{pessoa:x.pessoa,ator:x.act?x.act.client_id:null,saldo:140})}).listen(5861,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5861; G='&ator=agente-estoque'; v(){ sed "s/.*\"$1\":\"\([^\"]*\)\".*/\1/" $2; }
lg(){ curl -s "$S/login?delegar=agente-estoque$1"; }; tk(){ curl -s "$S/troca?subject=$(v token $1)$2"; }; es(){ curl -s "$S/estoque?token=$(v token $1)"; }
# 1. Sem a permissão: a delegação some calada; a troca do agente cai
echo; echo "== 1. Sem a permissão: a delegação some calada; a troca do agente cai"
lg | tee /tmp/b; tk /tmp/b $G
# 2. Com a permissão: may_act no token da Bia, act no do agente; o estoque vê os dois
echo; echo "== 2. Com a permissão: may_act no token da Bia, act no do agente; o estoque vê os dois"
curl -s "$S/permissao?liga=1"; lg | tee /tmp/b; tk /tmp/b $G | tee /tmp/a; es /tmp/a
# 3. Os atalhos: a troca padrão cai; mas o token da Bia abre o estoque, sem ator
echo; echo "== 3. Os atalhos: a troca padrão cai; mas o token da Bia abre o estoque, sem ator"
tk /tmp/b; es /tmp/b
# 4. O registro só para delegar: o estoque recusa o token da Bia; a troca passa
echo; echo "== 4. O registro só para delegar: o estoque recusa o token da Bia; a troca passa"
lg '&registro=delega' | tee /tmp/d; es /tmp/d; tk /tmp/d $G
# 5. A permissão retirada: a renovação sai sem may_act; o token de antes ainda troca
echo; echo "== 5. A permissão retirada: a renovação sai sem may_act; o token de antes ainda troca"
curl -s "$S/permissao?liga=0"; curl -s "$S/renova?token=$(v token /tmp/b)" | tee /tmp/r; tk /tmp/r $G; tk /tmp/b $G
kill %1
