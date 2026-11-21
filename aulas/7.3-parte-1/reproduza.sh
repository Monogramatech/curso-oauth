#!/usr/bin/env bash
# Aula 7.3, Parte 1: mTLS e DPoP: o token que não serve a quem o roubou.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/7.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
I=http://localhost:8080/realms/curso
# 1. Um client de serviço que só recebe token preso a uma chave (DPoP)
echo; echo "== 1. Um client de serviço que só recebe token preso a uma chave (DPoP)"
C=$($K create clients -r curso -s clientId=job-dpop -s serviceAccountsEnabled=true -s 'attributes."dpop.bound.access.tokens"=true' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
# 2. Um cliente DPoP de uma linha: gera a chave, pede o token com a prova e usa o token no userinfo do Keycloak
echo; echo "== 2. Um cliente DPoP de uma linha: gera a chave, pede o token com a prova e usa o token no userinfo do Keycloak"
I=$I S=$S node -e "require('dns').setDefaultResultOrder('ipv4first');var c=require('crypto'),E=process.env,k=c.generateKeyPairSync('ec',{namedCurve:'P-256'}),j=k.publicKey.export({format:'jwk'}),J={crv:j.crv,kty:j.kty,x:j.x,y:j.y},u=function(o){return Buffer.from(JSON.stringify(o)).toString('base64url')},h=function(x){return c.createHash('sha256').update(x).digest('base64url')};function prova(m,url,t){var s=u({typ:'dpop+jwt',alg:'ES256',jwk:J})+'.'+u(Object.assign({jti:c.randomUUID(),htm:m,htu:url,iat:Math.floor(Date.now()/1000)},t?{ath:h(t)}:{}));return s+'.'+c.sign('sha256',Buffer.from(s),{key:k.privateKey,dsaEncoding:'ieee-p1363'}).toString('base64url')}(async function(){var T=E.I+'/protocol/openid-connect/token',U=E.I+'/protocol/openid-connect/userinfo',f={'content-type':'application/x-www-form-urlencoded'},b='grant_type=client_credentials&scope=openid&client_id=job-dpop&client_secret='+E.S;var r=await fetch(T,{method:'POST',headers:f,body:b});console.log('1. token sem a prova:',r.status,(await r.json()).error_description);r=await(await fetch(T,{method:'POST',headers:Object.assign({dpop:prova('POST',T)},f),body:b})).json();var t=r.access_token;console.log('2. token com a prova:',r.token_type,'cnf.jkt =',JSON.parse(Buffer.from(t.split('.')[1],'base64url')).cnf.jkt);console.log('   a chave do cliente =',h(JSON.stringify(J)));r=await fetch(U,{headers:{authorization:'Bearer '+t}});console.log('3. o token como Bearer:',r.status);r=await fetch(U,{headers:{authorization:'DPoP '+t,dpop:prova('GET',U,t)}});console.log('4. com a prova da chave certa:',r.status)})()"
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
