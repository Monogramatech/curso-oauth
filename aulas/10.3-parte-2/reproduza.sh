#!/usr/bin/env bash
# Aula 10.3, Parte 2: A troca na fronteira: quem aceita o token do outro lado.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.3-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
# 1. O Cognito real, sem conta (só erros): o controle, um tipo de token inventado e um app inventado
echo; echo "== 1. O Cognito real, sem conta (só erros): o controle, um tipo de token inventado e um app inventado"
c() { curl -s https://cognito-idp.us-east-1.amazonaws.com/ -H "Content-Type: application/x-amz-json-1.1" -H "X-Amz-Target: AWSCognitoIdentityProviderService.$1" -d "$2"; echo; }
c Inventada '{}'
c GetDerivedToken '{"ClientId":"1example23456789abcdefghij","SubjectToken":"abc","SubjectTokenType":"X"}'
c GetDerivedToken '{"ClientId":"1example23456789abcdefghij","SubjectToken":"abc","SubjectTokenType":"ACCESS_TOKEN"}'
# 2. Servidor de troca mínimo do curso (5790, não é o Cognito): tokens opacos na memória; a Bia ligada, a Carla não
echo; echo "== 2. Servidor de troca mínimo do curso (5790, não é o Cognito): tokens opacos na memória; a Bia ligada, a Carla não"
node -e 'var T={},n=0,L={"u-0042-bia":"bia"};function tk(o){var k="t"+(n++);T[k]=o;return k}
function j(s,st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
require("http").createServer(function(q,s){var d="";q.on("data",function(x){d+=x});q.on("end",function(){
var u=new URL(q.url,"http://x"),p=Object.fromEntries(new URLSearchParams(d)),t=Math.floor(Date.now()/1000);
if(u.pathname=="/login")return s.end(tk({sub:u.searchParams.get("u"),scope:["entregas/ler"],exp:t+600})+"\n");
if(u.pathname=="/m2m")return s.end(tk({sub:"portal",scope:[],exp:t+3600})+"\n");
var x=p.subject_token_provider_name?{sub:L[p.subject_token],scope:[],exp:t+300}:T[p.subject_token];
if(x==null||x.sub==null)return j(s,400,{error:"invalid_request",error_description:"nenhum usuário ligado: a troca não cria usuário"});
var a=p.actor_token?T[p.actor_token]:null,pede=(p.scope||x.scope.join(" ")).split(" ");
var c={sub:x.sub,aud:p.audience,scope:pede.filter(function(e){return x.scope.indexOf(e)+1}).join(" "),exp:Math.min(t+3600,x.exp)};
if(a)c.act={sub:a.sub};j(s,200,{expires_in:c.exp-t,claims:c})})}).listen(5790,"127.0.0.1")' &
sleep 2
U=127.0.0.1:5790; B=$(curl -s $U/login?u=bia); P=$(curl -s $U/m2m)
x() { curl -s $U/token -d grant_type=urn:ietf:params:oauth:grant-type:token-exchange -d audience=entregas "$@"; }
# 3. A troca com o ator: a claim act, só o escopo que a Bia tem, a validade do token dela, sem refresh token
echo; echo "== 3. A troca com o ator: a claim act, só o escopo que a Bia tem, a validade do token dela, sem refresh token"
x -d subject_token=$B -d actor_token=$P --data-urlencode "scope=entregas/ler entregas/cancelar"
# 4. Sem o ator: sem a claim act
echo; echo "== 4. Sem o ator: sem a claim act"
x -d subject_token=$B
# 5. O token de fora da Carla, de um provedor registrado: ninguém ligado a ela
echo; echo "== 5. O token de fora da Carla, de um provedor registrado: ninguém ligado a ela"
x -d subject_token=u-0077-carla -d subject_token_provider_name=Loja
kill %1
