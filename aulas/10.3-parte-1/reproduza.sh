#!/usr/bin/env bash
# Aula 10.3, Parte 1: O que o AWS STS emite (e o que não emite).
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/10.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
# 1. O STS real, sem conta (só erros): o controle, uma chamada que pede assinatura e a troca do JWT
echo; echo "== 1. O STS real, sem conta (só erros): o controle, uma chamada que pede assinatura e a troca do JWT"
x() { node -e 'var x=require("fs").readFileSync(0)+"";console.log(x.split("Code")[1].slice(1,-2)+": "+x.split("Message")[1].slice(1,-2))'; }
S="https://sts.us-east-1.amazonaws.com/?Version=2011-06-15&Action"
curl -s "$S=Inventada" | x
curl -s "$S=GetWebIdentityToken&Audience.member.1=x&SigningAlgorithm=ES384" | x
curl -s "$S=AssumeRoleWithWebIdentity&RoleArn=arn:aws:iam::000000000000:role/inventado&RoleSessionName=bia&WebIdentityToken=abcd" | x
# 2. STS mínimo do curso (5790, não é a AWS): as regras do JWT de saída. Devolve as claims, sem assinar;
echo; echo "== 2. STS mínimo do curso (5790, não é a AWS): as regras do JWT de saída. Devolve as claims, sem assinar;"
#    no STS real, o sub da sessão vem do ID token conferido, e aqui vem direto no pedido
echo; echo "==    no STS real, o sub da sessão vem do ID token conferido, e aqui vem direto no pedido"
node -e 'var S={},R="arn:aws:iam::111122223333:role/portal-pedidos",ESC=["entregas:ler"];
function j(s,st,o){s.writeHead(st);s.end(JSON.stringify(o)+"\n")}
require("http").createServer(function(q,s){var u=new URL(q.url,"http://x"),p=Object.fromEntries(u.searchParams),t=Math.floor(Date.now()/1000);
if(u.pathname=="/assume"){var k="ASIA"+Object.keys(S).length;S[k]={sub:p.sub,exp:t+Number(p.dur||3600)};return j(s,200,{AccessKeyId:k,OriginIdentity:{Subject:p.sub}})}
var x=S[p.key],d=Number(p.dur||300),o=p.mode=="OriginIdentity";if(x==null)return j(s,403,{erro:"chave desconhecida"});
if(p.scope&&o);else if(p.scope)return j(s,400,{erro:"Scope só com SubjectMode=OriginIdentity"});
if(p.scope&&ESC.indexOf(p.scope)==-1)return j(s,403,{erro:"a política da função não permite este escopo"});
if(Math.max(0,t+d-x.exp))return j(s,403,{erro:"SessionDurationEscalation: o token passaria da sessão"});
var c={aud:"https://api.transportadora.example",sub:o?x.sub:R,exp:t+d};if(p.scope)c.scope=p.scope;
c["https://sts.amazonaws.com/"]={principal_id:R};j(s,200,c)}).listen(5790,"127.0.0.1")' &
sleep 2
T=127.0.0.1:5790/token?key=ASIA0
# 3. A sessão da Bia (15 minutos) e o JWT padrão: o sub é a função
echo; echo "== 3. A sessão da Bia (15 minutos) e o JWT padrão: o sub é a função"
curl -s -X POST "127.0.0.1:5790/assume?sub=u-0042-bia&dur=900"
curl -s "$T"
# 4. O modo de origem com escopo: o sub é a Bia; outro escopo e um JWT de 1 hora caem
echo; echo "== 4. O modo de origem com escopo: o sub é a Bia; outro escopo e um JWT de 1 hora caem"
curl -s "$T&mode=OriginIdentity&scope=entregas:ler"
curl -s "$T&mode=OriginIdentity&scope=entregas:cancelar"
curl -s "$T&dur=3600"
kill %1
