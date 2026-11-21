#!/usr/bin/env bash
# Aula 6.3, Parte 1: Mobile e desktop: navegador do sistema, esquemas de URL e loopback.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/6.3-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect
# 1. O app nativo é um cliente público, com PKCE, e o retorno em 127.0.0.1 fica registrado sem porta
echo; echo "== 1. O app nativo é um cliente público, com PKCE, e o retorno em 127.0.0.1 fica registrado sem porta"
C=$($K create clients -r curso -s clientId=receitas-cli -s publicClient=true -s 'redirectUris=["http://127.0.0.1/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -i)
# 2. A linha de comando: escuta só em 127.0.0.1, numa porta sorteada; confere o state, fecha a porta e troca o code
echo; echo "== 2. A linha de comando: escuta só em 127.0.0.1, numa porta sorteada; confere o state, fecha a porta e troca o code"
cli() { O=$O node -e "require('dns').setDefaultResultOrder('ipv4first');var c=require('crypto'),E=process.env,V=c.randomBytes(32).toString('base64url'),CH=c.createHash('sha256').update(V).digest('base64url'),ST=c.randomBytes(16).toString('base64url'),R,P;var s=require('http').createServer(async function(q,r){var u=new URL(q.url,'http://x');if(u.pathname=='/callback'&&u.searchParams.get('state')==ST){r.end('Pronto. Pode fechar esta aba e voltar ao terminal.');s.close();var t=await fetch(E.O+'/token',{method:'POST',body:new URLSearchParams({grant_type:'authorization_code',code:u.searchParams.get('code'),redirect_uri:R,client_id:'receitas-cli',code_verifier:V})});var j=await t.json();console.log('troca:',t.status,'| access token:',String(j.access_token).slice(0,12)+'...','| refresh token:',Boolean(j.refresh_token));process.exit()}r.writeHead(400);r.end('state ou caminho errado')});s.listen(0,'127.0.0.1',function(){P=s.address().port;R='http://127.0.0.1:'+P+'/callback';console.log('porta escolhida pelo sistema: '+P);console.log(E.O+'/auth?'+new URLSearchParams({response_type:'code',client_id:'receitas-cli',redirect_uri:R,scope:'openid',state:ST,code_challenge:CH,code_challenge_method:'S256'}))})"; }
# 3. Rode, abra o endereço que ela mostra e entre com voce / teste123. O navegador mostra "Pronto"; o terminal, a troca
echo; echo "== 3. Rode, abra o endereço que ela mostra e entre com voce / teste123. O navegador mostra 'Pronto'; o terminal, a troca"
cli
# 4. De novo: outra porta, e o navegador nem pede a senha. A sessão fica no navegador, não no app
echo; echo "== 4. De novo: outra porta, e o navegador nem pede a senha. A sessão fica no navegador, não no app"
cli
# 5. O retorno foi registrado sem porta: qualquer porta passa (200), mas o caminho tem de ser o mesmo (400)
echo; echo "== 5. O retorno foi registrado sem porta: qualquer porta passa (200), mas o caminho tem de ser o mesmo (400)"
X='&response_type=code&client_id=receitas-cli&scope=openid&code_challenge_method=S256&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM'
for U in http://127.0.0.1:1234/callback http://127.0.0.1:4321/callback http://127.0.0.1:1234/outro; do echo "$U: $(curl -s -o /dev/null -w '%{http_code}' "$O/auth?redirect_uri=$U$X")"; done
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$C -r curso
