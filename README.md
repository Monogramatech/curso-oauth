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
| [2.1 · Parte 1](aulas/2.1-parte-1/) | Resource owner, client, authorization server, resource server | `reproduza.sh` | 2 |
| [2.1 · Parte 2](aulas/2.1-parte-2/) | /authorize, /token e o canal da frente × o canal de trás | `reproduza.sh` | 2 |
| [2.2 · Parte 1](aulas/2.2-parte-1/) | Cliente público × confidencial, client_id, redirect_uri | `reproduza.sh` | 2 |
| [2.2 · Parte 2](aulas/2.2-parte-2/) | Escopo, consentimento e o parâmetro state | `reproduza.sh` | 2 |
| [3.1 · Parte 1](aulas/3.1-parte-1/) | Token opaco × JWT, e o token de portador (Bearer) | `reproduza.sh` | 2 |
| [3.1 · Parte 2](aulas/3.1-parte-2/) | Introspecção e revogação | `reproduza.sh` | 2 |
| [3.2 · Parte 1](aulas/3.2-parte-1/) | Cabeçalho, payload, assinatura e as claims padrão | `reproduza.sh` | 2 |
| [3.3 · Parte 1](aulas/3.3-parte-1/) | aud e scope: destino e poder | `reproduza.sh` | 2 |
| [3.3 · Parte 2](aulas/3.3-parte-2/) | Refresh token, expiração e rotação | `reproduza.sh` | 2 |

Cada pasta tem um README com o que a parte mostra, como reproduzir, os exercícios com uma boa resposta e as fontes.

## Licenças

- Os scripts (`*.sh`) estão sob a licença MIT: veja [LICENSE](LICENSE).
- Os textos (os README e as respostas dos exercícios) estão sob a CC BY 4.0: veja [LICENSE-CC-BY-4.0](LICENSE-CC-BY-4.0).
  Pode reutilizar e adaptar, citando a fonte: "OAuth: do login aos agentes", canal Monograma.
