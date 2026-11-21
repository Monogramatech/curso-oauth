#!/usr/bin/env bash
# Aula 12.2, Parte 1: Login no Next.js com BFF: onde ficam os tokens.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/12.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),K=C.randomBytes(32),H=C.randomBytes(32),R={};function ag(){return Date.now()/1e3|0}
function tk(c){var x=Buffer.from(JSON.stringify(c)).toString("base64url");return x+"."+C.createHmac("sha256",H).update(x).digest("base64url")}
function lt(t){var x=String(t).split(".");if(C.createHmac("sha256",H).update(x[0]).digest("base64url")==x[1])return JSON.parse(Buffer.from(x[0],"base64url"));return 0}
function cifra(o){var iv=C.randomBytes(12),c=C.createCipheriv("aes-256-gcm",K,iv),d=Buffer.concat([c.update(JSON.stringify(o)),c.final()]);return Buffer.concat([iv,c.getAuthTag(),d]).toString("base64url")}
function decifra(s){try{var b=Buffer.from(s,"base64url"),d=C.createDecipheriv("aes-256-gcm",K,b.subarray(0,12));d.setAuthTag(b.subarray(12,28));return JSON.parse(Buffer.concat([d.update(b.subarray(28)),d.final()]))}catch(e){return 0}}
function emite(){var r=C.randomBytes(16).toString("hex");R[r]=1;return{a:tk({sub:"voce",aud:"api-pedidos",exp:ag()+5}),r:r}}
function api(a){var c=lt(a);if(c)0;else return[401,"assinatura"];if(c.aud=="api-pedidos")0;else return[401,"audiencia"];if(Math.max(0,ag()-c.exp+1))return[401,"vencido"];return[200,c.sub]}
require("http").createServer(function(q,s){var m=/sessao=([^;]+)/.exec(q.headers.cookie||""),ss=m?decifra(m[1]):0,u=q.url,ck=function(o){return "sessao="+cifra(o)+"; HttpOnly; SameSite=Lax; Path=/"};
function j(st,o,c){s.writeHead(st,c?{"Set-Cookie":c}:{});s.end(JSON.stringify(o)+"\n")}
if(u=="/entrar"){var t=emite();return j(200,{entrou:"voce"},ck({nome:"voce",a:t.a,r:t.r}))}
if(ss)0;else return j(401,{erro:"sem sessao"});
if(u=="/sessao")return j(200,{nome:ss.nome});
if(u=="/sair"){delete R[ss.r];return j(200,{saiu:"refresh token revogado"},"sessao=; Max-Age=0; Path=/")}
var v=api(ss.a),novo=0;if(v[1]=="vencido"){if(R[ss.r])0;else return j(401,{erro:"o emissor recusou a renovacao"},"sessao=; Max-Age=0; Path=/");delete R[ss.r];var t=emite();ss.a=t.a;ss.r=t.r;novo=ck(ss);v=api(ss.a)}
j(v[0],{api:v[0],pessoa:v[1],renovou:novo?1:0},novo)}).listen(5730,"127.0.0.1")' &
sleep 2
S=127.0.0.1:5730; J=/tmp/painel.txt; J2=/tmp/copia.txt
# 1. Entrar: o navegador recebe só o cookie cifrado; a sessão que a página lê não traz token
echo; echo "== 1. Entrar: o navegador recebe só o cookie cifrado; a sessão que a página lê não traz token"
curl -s -c $J $S/entrar; curl -s -b $J $S/sessao
# 2. Os pedidos pelo BFF; 6 s depois, o token venceu, e o BFF renova sozinho
echo; echo "== 2. Os pedidos pelo BFF; 6 s depois, o token venceu, e o BFF renova sozinho"
curl -s -b $J -c $J $S/pedidos; sleep 6; curl -s -b $J -c $J $S/pedidos
# 3. Alguém copia o cookie; a pessoa sai (o BFF revoga o refresh token)
echo; echo "== 3. Alguém copia o cookie; a pessoa sai (o BFF revoga o refresh token)"
cp $J $J2; curl -s -b $J -c $J $S/sair
# 4. O cookie copiado ainda vale enquanto o access token vale; depois, a renovação é recusada
echo; echo "== 4. O cookie copiado ainda vale enquanto o access token vale; depois, a renovação é recusada"
curl -s -b $J2 $S/pedidos; sleep 6; curl -s -b $J2 $S/pedidos
kill %1
