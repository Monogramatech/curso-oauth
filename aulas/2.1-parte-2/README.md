# Aula 2.1, Parte 2: /authorize, /token e o canal da frente × o canal de trás

**No vídeo:** /authorize e /token: o code pode ir no endereço, o token não

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

O código de autorização passou pela barra de endereço do navegador. Mesmo assim, quando o laboratório tentou usar o mesmo code pela segunda vez, o servidor recusou. Veja os dois endpoints do OAuth, os dois caminhos das mensagens e por que o code pode ir no endereço, mas o access token não.

Nesta parte você vê:
- o endpoint de autorização (fala com a pessoa) e o de token (fala com o client);
- o canal da frente: o endereço, o redirecionamento 302 e quem lê esse endereço;
- o canal de trás: o POST direto, com o code e o verifier no corpo (e o caso do SPA);
- por que o code pode vazar sem estrago: expira logo, vale uma vez e está preso ao PKCE;
- o token fora do endereço, e o fluxo implícito que a RFC 9700 desaconselha;
- state, client_id e client_secret: o que é segredo e o que não é;
- os metadados da RFC 8414.

## Reproduza

Os comandos leem os metadados, fazem um login separando os dois canais, repetem o mesmo code e trocam um code sem o verifier. Os valores saem diferentes dos da tela.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/2.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Destes seis itens, quais podem viajar no canal da frente? Client id, state, code, code verifier, access token e o segredo do client.

<details><summary>Uma boa resposta</summary>

O client id, o state e o code podem. O code verifier, o access token e o segredo do client, nunca.

</details>

### Exercício 2

Para não perder o token ao recarregar a página, um app guarda o access token no endereço. Qual o problema?

<details><summary>Uma boa resposta</summary>

O token fica exposto como tudo no endereço, no histórico e nos registros dos servidores. Onde guardar o token é assunto do Módulo 6.

</details>

## Fontes

- RFC 6749 (IETF, out/2012), seções 3, 3.1, 3.2, 4.1.2 e 5.1
- RFC 8414 (IETF, jun/2018), seções 2, 3 e 5
- RFC 9700 (IETF, jan/2025), seções 2.1.1, 2.1.2, 4.2 e 4.3.2
- RFC 9207 (IETF, mar/2022) · RFC 9110 (IETF, jun/2022), seção 10.1.3
- MDN, Referrer-Policy (consultado em nov/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
