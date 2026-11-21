#!/usr/bin/env bash
# Aula 11.1, Parte 2: Autorização no MCP.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/11.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
node -e 'var C=require("crypto"),K=C.randomBytes(32),B="http://127.0.0.1:5490",M=B+"/mcp",R=B+"/.well-known/oauth-protected-resource/mcp";
function b(x){return Buffer.from(JSON.stringify(x)).toString("base64url")}function g(x){return C.createHmac("sha256",K).update(x).digest("base64url")}
function q(s,c,o,w){s.writeHead(c,w?{"WWW-Authenticate":"Bearer "+w}:{});s.end(JSON.stringify(o)+"\n")}
require("http").createServer(function(r,s){var t="";r.on("data",function(x){t+=x});r.on("end",function(){var p,m,c,e,x;
if(r.url=="/token"){p=new URLSearchParams(t);x=b({sub:"bia",aud:p.get("aud"),scope:p.get("scope"),exp:Date.now()/1e3+300|0});return q(s,200,{t:x+"."+g(x)})}
if(r.url=="/.well-known/oauth-protected-resource/mcp")return q(s,200,{resource:M,authorization_servers:[B],scopes_supported:["mcp:ler"]});
m=JSON.parse(t||"{}");x=String(r.headers.authorization).slice(7).split(".");try{c=g(x[0])==x[1]&&JSON.parse(Buffer.from(x[0],"base64url"))}catch(z){}
if(c&&Math.max(0,c.exp-Date.now()/1e3))0;else return q(s,401,{},"resource_metadata=\""+R+"\", scope=\"mcp:ler\"");
if(c.aud==M)0;else return q(s,401,{},"error=\"invalid_token\", error_description=\"the token was not issued for this server\"");
if(m.method=="tools/list")return q(s,200,{jsonrpc:"2.0",id:m.id,result:{resultType:"complete",tools:[{name:"consultar_pedido"},{name:"cancelar_pedido"}]}});
e=m.params.name=="cancelar_pedido"?"mcp:escrever":"mcp:ler";if(c.scope.split(" ").indexOf(e)+1)return q(s,200,{jsonrpc:"2.0",id:m.id,result:{resultType:"complete",content:[{type:"text",text:"feito"}]}});
q(s,403,{},"error=\"insufficient_scope\", scope=\""+e+"\", resource_metadata=\""+R+"\"")})}).listen(5490,"127.0.0.1")' &
sleep 2
S=http://127.0.0.1:5490; v() { sed 's/.*"t":"//;s/".*//'; }
m() { curl -s -i $S/mcp -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -H "MCP-Protocol-Version: 2026-07-28" -H "Mcp-Method: $1" ${2:+-H "Mcp-Name: $2"} -H "Authorization: Bearer $3" -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$1\",\"params\":{${2:+\"name\":\"$2\",}\"_meta\":{\"io.modelcontextprotocol/protocolVersion\":\"2026-07-28\"}}}" | grep -i -E "^HTTP|^www-auth|^\{"; }
# 1. Sem token: 401 com o endereço dos metadados; os metadados respondem sem token
echo; echo "== 1. Sem token: 401 com o endereço dos metadados; os metadados respondem sem token"
m tools/list; curl -s $S/.well-known/oauth-protected-resource/mcp
# 2. Token para o servidor MCP, com leitura: a lista vem (200); um token de outra API leva 401
echo; echo "== 2. Token para o servidor MCP, com leitura: a lista vem (200); um token de outra API leva 401"
T=$(curl -s $S/token -d "aud=$S/mcp&scope=mcp:ler" | v); m tools/list "" $T
O=$(curl -s $S/token -d "aud=http://127.0.0.1:5483/pedidos&scope=mcp:ler" | v); m tools/list "" $O
# 3. Cancelar pede escrita: 403 com o escopo que falta; com a união dos dois escopos, 200
echo; echo "== 3. Cancelar pede escrita: 403 com o escopo que falta; com a união dos dois escopos, 200"
m tools/call cancelar_pedido $T
U=$(curl -s $S/token -d "aud=$S/mcp&scope=mcp:ler mcp:escrever" | v); m tools/call cancelar_pedido $U
kill %1
