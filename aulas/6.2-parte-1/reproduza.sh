#!/usr/bin/env bash
# Aula 6.2, Parte 1: O padrão BFF e o token que nunca chega ao navegador.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/6.2-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
O=http://localhost:8080/realms/curso/protocol/openid-connect; R=http://bff.localhost:6400/bff/callback
# 1. O BFF é um cliente confidencial: tem um segredo, com PKCE
echo; echo "== 1. O BFF é um cliente confidencial: tem um segredo, com PKCE"
C=$($K create clients -r curso -s clientId=receitas-bff -s 'redirectUris=["http://bff.localhost:6400/bff/callback"]' -s 'attributes."pkce.code.challenge.method"=S256' -i)
S=$($K get clients/$C/client-secret -r curso --fields value --format csv --noquotes)
V=$(openssl rand -base64 48 | tr -d '=+/\n' | cut -c1-64); CH=$(printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
# 2. Um BFF mínimo, só para ver (deixe rodando): troca o code com o segredo e devolve só um cookie; repassa o perfil à API. Um de verdade também confere o state
echo; echo "== 2. Um BFF mínimo, só para ver (deixe rodando): troca o code com o segredo e devolve só um cookie; repassa o perfil à API. Um de verdade também confere o state"
O=$O R=$R S=$S V=$V node -e "require('dns').setDefaultResultOrder('ipv4first');var E=process.env,T={};require('http').createServer(async function(q,s){var u=new URL(q.url,'http://x');if(u.pathname=='/bff/callback'){var r=await fetch(E.O+'/token',{method:'POST',headers:{authorization:'Basic '+Buffer.from('receitas-bff:'+E.S).toString('base64')},body:new URLSearchParams({grant_type:'authorization_code',code:u.searchParams.get('code'),redirect_uri:E.R,code_verifier:E.V})});T=await r.json();s.writeHead(302,{location:'/','set-cookie':'__Host-Http-sessao=abc123; Secure; HttpOnly; SameSite=Strict; Path=/'});return s.end()}if(u.pathname=='/bff/perfil'){if(q.headers['bff-csrf']=='1'&&(q.headers.cookie||'').includes('sessao=abc123')){var p=await fetch(E.O+'/userinfo',{headers:{authorization:'Bearer '+T.access_token}});return s.end(await p.text())}s.writeHead(403);return s.end('sem o cabecalho bff-csrf ou sem a sessao')}s.end('app de receitas com BFF: abra o console (F12)')}).listen(6400)" &
# 3. Abra o endereço e entre com voce / teste123. A volta cai no BFF, que troca o code e leva você à página do app
echo; echo "== 3. Abra o endereço e entre com voce / teste123. A volta cai no BFF, que troca o code e leva você à página do app"
echo "$O/auth?response_type=code&client_id=receitas-bff&redirect_uri=$R&scope=openid&state=abc&code_challenge=$CH&code_challenge_method=S256"
# 4. No console (F12), o script não vê a sessão (document.cookie), mas o perfil vem pelo BFF:
echo; echo "== 4. No console (F12), o script não vê a sessão (document.cookie), mas o perfil vem pelo BFF:"
#    fetch('/bff/perfil',{headers:{'bff-csrf':'1'}}).then(function(r){return r.text()}).then(console.log)
echo; echo "==    fetch('/bff/perfil',{headers:{'bff-csrf':'1'}}).then(function(r){return r.text()}).then(console.log)"
# 5. Sem o cabeçalho fixo, o BFF recusa, mesmo com o cookie: é a defesa contra CSRF
echo; echo "== 5. Sem o cabeçalho fixo, o BFF recusa, mesmo com o cookie: é a defesa contra CSRF"
curl -s http://127.0.0.1:6400/bff/perfil -H "Cookie: __Host-Http-sessao=abc123"; echo
# Desfaz
echo; echo "== Desfaz"
kill %1; $K delete clients/$C -r curso
