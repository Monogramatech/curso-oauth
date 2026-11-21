# Aula 4.3, Parte 1: Device Authorization Grant: TV, CLI e IoT

**No vídeo:** Device Code: o login da TV feito pelo celular

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Device Code no laboratório: uma TV sem teclado mostrou um código, a senha foi digitada no celular, e o token chegou à TV.

Nesta parte você vê:
- por que o Authorization Code não serve numa TV ou num terminal sem navegador;
- o pedido do código: o device_code, o user_code e o endereço;
- os dois aparelhos ao mesmo tempo: a TV consulta, o celular aprova;
- cada resposta da consulta: authorization_pending, slow_down, access_denied, expired_token;
- o cuidado com um código que chega por mensagem, e onde usar o fluxo.

## Reproduza

A TV é o terminal: ele pede o código e consulta; o login é no navegador.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Uma ferramenta de terminal roda num servidor, sem navegador, e precisa agir com a sua conta. Qual fluxo ela usa?

<details><summary>Uma boa resposta</summary>

O Device Code, porque ela age com a sua conta e não tem navegador. O fluxo da Aula 4.2 daria um token sem pessoa.

</details>

### Exercício 2

Uma visita vê o código curto na tela da sua TV. Ela consegue o token da sua conta?

<details><summary>Uma boa resposta</summary>

Não. O token só sai para quem tem o código do aparelho, e esse código nunca aparece na tela.

</details>

## Fontes

- RFC 8628, OAuth 2.0 Device Authorization Grant (ago/2019), seções 1, 3, 5 e 6.1
- Microsoft Learn, Authentication flows as a condition in Conditional Access policy (14/11/2026)
- Microsoft Learn, OAuth 2.0 device authorization grant (14/11/2026)
- Laboratório: Keycloak 26.4 local
