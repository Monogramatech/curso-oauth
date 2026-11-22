# OAuth: do login aos agentes

O laboratório e as respostas dos exercícios do curso **"OAuth: do login aos agentes"**, do canal Monograma no YouTube:
OAuth 2.0 e OpenID Connect para devs de qualquer linguagem, do login à delegação entre serviços e agentes de IA.
Toda requisição e todo token que aparecem nos vídeos saíram deste laboratório.

## O que você precisa

- Docker
- um terminal bash: Linux, macOS, WSL ou Git Bash no Windows
- `curl`, `openssl` e Node.js 18 ou mais novo
- um navegador, para os logins (use janelas anônimas)

## Comece aqui

```bash
git clone https://github.com/Monogramatech/curso-oauth.git
cd curso-oauth
bash laboratorio/preparo.sh     # Keycloak 26.4 em localhost:8080, com o realm "curso"
bash laboratorio/login.sh       # um login de verdade, com PKCE, e a primeira chamada com o token
```

Depois, cada parte tem o seu script: `bash aulas/<parte>/reproduza.sh`. Para apagar o laboratório: `docker rm -f kc`.

> **Só para estudo.** As senhas (`admin` / `admin`, `voce` / `teste123`) são de teste, e o Keycloak roda em modo de
> desenvolvimento, só em `localhost`. Não use esta configuração em produção.

## As partes

| Parte | Tema | Laboratório | Exercícios |
| --- | --- | --- | --- |
| [0.1 · Parte 1](aulas/0.1-parte-1/) | Da senha compartilhada ao token delegado | — | 2 |
| [0.2 · Parte 1](aulas/0.2-parte-1/) | Um clique em "Entrar com…", passo a passo | `laboratorio/` | 2 |
| [1.1 · Parte 1](aulas/1.1-parte-1/) | Base64url não é segurança: codificação, hash e cifra | `reproduza.sh` | 2 |
| [1.1 · Parte 2](aulas/1.1-parte-2/) | Assinatura digital: HMAC × chave pública | `reproduza.sh` | 2 |
| [1.2 · Parte 1](aulas/1.2-parte-1/) | JWK, JWKS, kid e rotação de chaves | `reproduza.sh` | 2 |
| [10.1 · Parte 1](aulas/10.1-parte-1/) | Trust domains e JWT como grant (RFC 7523) | `reproduza.sh` | 2 |
| [10.1 · Parte 2](aulas/10.1-parte-2/) | Federação de workloads: tokens de um provedor aceitos por outro | `reproduza.sh` | 2 |
| [10.2 · Parte 1](aulas/10.2-parte-1/) | Claims do Entra (oid, tid, grupos, papéis) e o fluxo On-Behalf-Of | `reproduza.sh` | 2 |
| [10.2 · Parte 2](aulas/10.2-parte-2/) | Os limites do OBO: por que ele não atravessa para outro domínio | `reproduza.sh` | 2 |
| [10.3 · Parte 1](aulas/10.3-parte-1/) | O que o AWS STS emite (e o que não emite) | `reproduza.sh` | 2 |
| [10.3 · Parte 2](aulas/10.3-parte-2/) | A troca na fronteira: quem aceita o token do outro lado | `reproduza.sh` | 2 |
| [10.4 · Parte 1](aulas/10.4-parte-1/) | Identity chaining across domains | `reproduza.sh` | 2 |
| [10.4 · Parte 2](aulas/10.4-parte-2/) | Transaction Tokens | `reproduza.sh` | 2 |
| [11.1 · Parte 1](aulas/11.1-parte-1/) | Identidade própria para o agente e o agente no act | `reproduza.sh` | 2 |
| [11.1 · Parte 2](aulas/11.1-parte-2/) | Autorização no MCP | `reproduza.sh` | 2 |
| [11.2 · Parte 1](aulas/11.2-parte-1/) | O token expira no meio da tarefa | `reproduza.sh` | 2 |
| [11.2 · Parte 2](aulas/11.2-parte-2/) | Aprovação humana: CIBA e step-up | `reproduza.sh` | 2 |
| [12.1 · Parte 1](aulas/12.1-parte-1/) | Entrar com Google num app web: o ID token e três erros | `reproduza.sh` | 2 |
| [12.2 · Parte 1](aulas/12.2-parte-1/) | Login no Next.js com BFF: onde ficam os tokens | `reproduza.sh` | 2 |
| [12.3 · Parte 1](aulas/12.3-parte-1/) | Refresh token no app de celular: o login que dura semanas | `reproduza.sh` | 2 |
| [12.4 · Parte 1](aulas/12.4-parte-1/) | Client credentials em produção: um client por sistema e a chave vazada | `reproduza.sh` | 2 |
| [12.5 · Parte 1](aulas/12.5-parte-1/) | Apps de terceiros com OAuth: registro, consentimento e revogação | `reproduza.sh` | 2 |
| [12.6 · Parte 1](aulas/12.6-parte-1/) | Device code na CLI e na TV: o golpe do código e as defesas | `reproduza.sh` | 2 |
| [12.7 · Parte 1](aulas/12.7-parte-1/) | Entra e Keycloak: a ponte entre provedores (RFC 7523) | `reproduza.sh` | 2 |
| [12.7 · Parte 2](aulas/12.7-parte-2/) | Agente de IA com delegação no Keycloak: may_act e act | `reproduza.sh` | 2 |
| [12.8 · Parte 1](aulas/12.8-parte-1/) | Agente de IA com ferramentas MCP: o token de cada salto | `reproduza.sh` | 2 |
| [2.1 · Parte 1](aulas/2.1-parte-1/) | Resource owner, client, authorization server, resource server | `reproduza.sh` | 2 |
| [2.1 · Parte 2](aulas/2.1-parte-2/) | /authorize, /token e o canal da frente × o canal de trás | `reproduza.sh` | 2 |
| [2.2 · Parte 1](aulas/2.2-parte-1/) | Cliente público × confidencial, client_id, redirect_uri | `reproduza.sh` | 2 |
| [2.2 · Parte 2](aulas/2.2-parte-2/) | Escopo, consentimento e o parâmetro state | `reproduza.sh` | 2 |
| [3.1 · Parte 1](aulas/3.1-parte-1/) | Token opaco × JWT, e o token de portador (Bearer) | `reproduza.sh` | 2 |
| [3.1 · Parte 2](aulas/3.1-parte-2/) | Introspecção e revogação | `reproduza.sh` | 2 |
| [3.2 · Parte 1](aulas/3.2-parte-1/) | Cabeçalho, payload, assinatura e as claims padrão | `reproduza.sh` | 2 |
| [3.2 · Parte 2](aulas/3.2-parte-2/) | Conferir as claims em ordem | `reproduza.sh` | 2 |
| [3.3 · Parte 1](aulas/3.3-parte-1/) | aud e scope: destino e poder | `reproduza.sh` | 2 |
| [3.3 · Parte 2](aulas/3.3-parte-2/) | Refresh token, expiração e rotação | `reproduza.sh` | 2 |
| [4.1 · Parte 1](aulas/4.1-parte-1/) | O fluxo completo, requisição por requisição | `reproduza.sh` | 2 |
| [4.1 · Parte 2](aulas/4.1-parte-2/) | O ataque que o PKCE resolve | `reproduza.sh` | 2 |
| [4.1 · Parte 3](aulas/4.1-parte-3/) | PKCE por dentro: code_verifier, code_challenge e S256 | `reproduza.sh` | 2 |
| [4.2 · Parte 1](aulas/4.2-parte-1/) | Serviço falando com serviço, sem usuário | `reproduza.sh` | 2 |
| [4.3 · Parte 1](aulas/4.3-parte-1/) | Device Authorization Grant: TV, CLI e IoT | `reproduza.sh` | 2 |
| [4.3 · Parte 2](aulas/4.3-parte-2/) | Implicit e Password: por que saíram | `reproduza.sh` | 2 |
| [5.1 · Parte 1](aulas/5.1-parte-1/) | O que o OIDC acrescenta: escopo openid, ID token, UserInfo | `reproduza.sh` | 2 |
| [5.1 · Parte 2](aulas/5.1-parte-2/) | ID token × access token: quem consome cada um | `reproduza.sh` | 2 |
| [5.2 · Parte 1](aulas/5.2-parte-1/) | As duas sessões e o logout pedido pelo app (RP-Initiated Logout) | `reproduza.sh` | 2 |
| [5.2 · Parte 2](aulas/5.2-parte-2/) | Avisar os outros apps: front-channel e back-channel logout | `reproduza.sh` | 2 |
| [6.1 · Parte 1](aulas/6.1-parte-1/) | Back-end web clássico: sessão por cookie e tokens no servidor | `reproduza.sh` | 2 |
| [6.1 · Parte 2](aulas/6.1-parte-2/) | SPA: onde guardar o token e por que não no localStorage | `reproduza.sh` | 2 |
| [6.2 · Parte 1](aulas/6.2-parte-1/) | O padrão BFF e o token que nunca chega ao navegador | `reproduza.sh` | 2 |
| [6.3 · Parte 1](aulas/6.3-parte-1/) | Mobile e desktop: navegador do sistema, esquemas de URL e loopback | `reproduza.sh` | 2 |
| [7.1 · Parte 1](aulas/7.1-parte-1/) | Validar token em toda requisição: middleware, cache de JWKS, erros 401 e 403 | `reproduza.sh` | 2 |
| [7.1 · Parte 2](aulas/7.1-parte-2/) | Escopo, papel e claim: do token à decisão de acesso | `reproduza.sh` | 2 |
| [7.2 · Parte 1](aulas/7.2-parte-1/) | Validar na borda, validar em cada serviço, ou os dois | `reproduza.sh` | 2 |
| [7.3 · Parte 1](aulas/7.3-parte-1/) | mTLS e DPoP: o token que não serve a quem o roubou | `reproduza.sh` | 2 |
| [7.3 · Parte 2](aulas/7.3-parte-2/) | PAR e RAR: pedidos de autorização seguros e detalhados | `reproduza.sh` | 2 |
| [8.1 · Parte 1](aulas/8.1-parte-1/) | CSRF, redirecionamento aberto e roubo de código | `reproduza.sh` | 2 |
| [8.1 · Parte 2](aulas/8.1-parte-2/) | Mix-up, token em log e confused deputy | `reproduza.sh` | 2 |
| [8.2 · Parte 1](aulas/8.2-parte-1/) | O checklist de segurança do OAuth em 2026 | `reproduza.sh` | 2 |
| [9.1 · Parte 1](aulas/9.1-parte-1/) | Token passthrough e client credentials: o que cada um apaga na cadeia | `reproduza.sh` | 2 |
| [9.2 · Parte 1](aulas/9.2-parte-1/) | Os parâmetros: subject_token, actor_token, audience, scope | `reproduza.sh` | 2 |
| [9.2 · Parte 2](aulas/9.2-parte-2/) | Impersonificação × delegação | `reproduza.sh` | 2 |
| [9.3 · Parte 1](aulas/9.3-parte-1/) | act aninhado e may_act | `reproduza.sh` | 2 |
| [9.3 · Parte 2](aulas/9.3-parte-2/) | Downscoping por salto e permissão efetiva = usuário ∩ ator | `reproduza.sh` | 2 |
| [9.3 · Parte 3](aulas/9.3-parte-3/) | Rastreabilidade: txn, logs de troca e auditoria | `reproduza.sh` | 2 |

Cada pasta tem um README com o que a parte mostra, como reproduzir, os exercícios com uma boa resposta e as fontes.

## Licenças

- Os scripts (`*.sh`) estão sob a licença MIT: veja [LICENSE](LICENSE).
- Os textos (os README e as respostas dos exercícios) estão sob a CC BY 4.0: veja [LICENSE-CC-BY-4.0](LICENSE-CC-BY-4.0).
  Pode reutilizar e adaptar, citando a fonte: "OAuth: do login aos agentes", canal Monograma.
