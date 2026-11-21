# Aula 6.1, Parte 2: SPA: onde guardar o token e por que não no localStorage

**No vídeo:** Onde guardar o token numa SPA: localStorage ou memória?

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Onde guardar o token numa SPA: no localStorage, um script injetado leva o refresh token embora; na memória, ele ainda pede tokens novos.

Nesta parte você vê:
- a SPA como cliente público: PKCE e a troca do code pelo navegador;
- os tokens que chegam ao navegador, e o CORS que deixa a página ler a resposta;
- o localStorage lido por um XSS e o refresh token usado de fora;
- o token na memória: o que o script não acha e o que ele ainda faz;
- o iframe escondido que pede tokens novos (RFC 10017);
- o que encerra os tokens roubados, e por que a RFC recomenda o BFF.

## Reproduza

O cliente público, a troca pelo console do navegador, o localStorage, o pedido silencioso e o sair.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/6.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Compare o app com servidor, da Parte 1, com a SPA que guarda o token na memória. O que um XSS consegue em cada um?

<details><summary>Uma boa resposta</summary>

No app com servidor, o script usa a sessão só com a página aberta. Na SPA, também leva tokens, que valem de fora com a página fechada.

</details>

### Exercício 2

Com a rotação ligada, o script roubou o refresh token e apagou os tokens do app. A rotação percebe o roubo?

<details><summary>Uma boa resposta</summary>

Não. O app não tem mais o refresh token, então só o atacante usa, e nunca há reuso. A RFC 10017 descreve esse truque.

</details>

## Fontes

- RFC 10017 (ago/2026), BCP 212, OAuth 2.0 for Browser-Based Applications: seções 5.1, 6.1.4.3, 6.3 e 8
- RFC 9700 (jan/2025), seção 4.14.2
- OpenID Connect Core 1.0 (errata 2, dez/2023), seção 3.1.2.1
- Laboratório: Keycloak 26.4 local e Edge 157
