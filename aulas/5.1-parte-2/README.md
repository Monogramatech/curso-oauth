# Aula 5.1, Parte 2: ID token × access token: quem consome cada um

**No vídeo:** ID token ou access token: quem consome cada um

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

ID token ou access token? Uma opção no servidor tirou do access token o nome, o e-mail e até o sub; o ID token do mesmo login continuou com tudo.

Nesta parte você vê:
- os três tokens da resposta e o destino de cada um, pelo aud;
- o userinfo diante de cada token: 200, 401 e 401;
- por que a API recusa o ID token (RFC 9700 e RFC 9068);
- por que o app não abre o access token, com o access token enxuto do Keycloak;
- a introspecção, para a API saber quem é a pessoa;
- quem recebe, confere e usa cada token.

## Reproduza

O destino de cada token, o userinfo diante dos três e o access token enxuto.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/5.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O app no navegador manda o ID token para a API, no cabeçalho Authorization. O que está errado, e o que muda?

<details><summary>Uma boa resposta</summary>

O ID token é para o app, e a API deve recusar. O app manda um access token, com a API no aud e o scope.

</details>

### Exercício 2

O access token vence a cada cinco minutos. Para não depender do app, a API poderia receber o refresh token e renovar sozinha?

<details><summary>Uma boa resposta</summary>

Não. Pela RFC 6749, o refresh token nunca vai a uma API, só ao servidor. Quem renova é o app.

</details>

## Fontes

- OpenID Connect Core 1.0, errata set 2 (dez/2023), seções 2, 3.1.3.7 e 5.3
- RFC 6749 (out/2012), seções 1.4 e 1.5
- RFC 9700 (jan/2025), seção 2.3
- RFC 9068 (out/2021), seções 2.1, 4, 5 e 6
- OAuth 2.1, draft-ietf-oauth-v2-1-17 (31/10/2026), seção 1.4
- Laboratório: Keycloak 26.4 local
