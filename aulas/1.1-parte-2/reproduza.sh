#!/usr/bin/env bash
# Aula 1.1, Parte 2: Assinatura digital: HMAC × chave pública.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/1.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
# HS256: quem tem o segredo assina, confere e também fabrica (aqui, um token com o escopo de apagar fotos)
echo; echo "== HS256: quem tem o segredo assina, confere e também fabrica (aqui, um token com o escopo de apagar fotos)"
unalias -a
node -e "const c=require('crypto'),b=function(o){return Buffer.from(JSON.stringify(o)).toString('base64url')},e=b({alg:'HS256',typ:'JWT'})+'.'+b({sub:'voce',scope:'fotos:apagar'});console.log(e+'.'+c.createHmac('sha256','segredo-de-teste').update(e).digest('base64url'))"
# RS256: confira o seu access token com a chave pública do JWKS, achada pelo kid
echo; echo "== RS256: confira o seu access token com a chave pública do JWKS, achada pelo kid"
node -e "fetch('http://127.0.0.1:8080/realms/curso/protocol/openid-connect/certs').then(function(r){return r.json()}).then(function(j){const c=require('crypto'),p=process.argv[1].split('.'),kid=JSON.parse(Buffer.from(p[0],'base64url')).kid,k=j.keys.find(function(x){return x.kid===kid});console.log('kid',kid,'confere:',c.verify('sha256',Buffer.from(p[0]+'.'+p[1]),c.createPublicKey({key:k,format:'jwk'}),Buffer.from(p[2],'base64url')))})" "$T"
# O cabeçalho do refresh token, da mesma resposta do passo 3: alg HS512
echo; echo "== O cabeçalho do refresh token, da mesma resposta do passo 3: alg HS512"
# (R veio do login do começo)
node -e "console.log(Buffer.from(process.argv[1].split('.')[0],'base64url').toString())" "$R"
# ES256: o mesmo texto assinado duas vezes dá duas assinaturas diferentes, e as duas conferem
echo; echo "== ES256: o mesmo texto assinado duas vezes dá duas assinaturas diferentes, e as duas conferem"
node -e "const c=require('crypto'),p=c.generateKeyPairSync('ec',{namedCurve:'P-256'}),m=Buffer.from('cabecalho.corpo'),o={key:p.privateKey,dsaEncoding:'ieee-p1363'},v={key:p.publicKey,dsaEncoding:'ieee-p1363'},a=c.sign('sha256',m,o),b=c.sign('sha256',m,o);console.log(a.length+' bytes','iguais:',a.equals(b),'conferem:',c.verify('sha256',m,v,a),c.verify('sha256',m,v,b))"
