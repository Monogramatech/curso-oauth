# Aula 6.2, Parte 1: O padrão BFF e o token que nunca chega ao navegador

**No vídeo:** BFF: o token que nunca chega ao navegador

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

BFF, o back-end do front-end: o servidor do app faz o login como cliente confidencial, guarda os tokens, e o navegador fica só com um cookie.

Nesta parte você vê:
- as três tarefas do BFF na RFC 10017;
- o login pelo BFF, com segredo e PKCE, e a sessão no servidor;
- o cookie com HttpOnly, Secure, SameSite Strict e o prefixo __Host-Http-;
- a defesa contra CSRF com um cabeçalho fixo;
- os ataques da aula anterior contra o BFF, e o que ainda sobra;
- as três arquiteturas lado a lado: SPA, back-end que só entrega o token e BFF.

## Reproduza

O cliente confidencial, um BFF mínimo que devolve só o cookie, o perfil pelo BFF e o cabeçalho contra CSRF.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/6.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Numa SPA com BFF, desenhe por onde passa o token, do login até a API.

<details><summary>Uma boa resposta</summary>

O code passa pelo navegador até o BFF. Os tokens ficam no BFF, e só o access token vai à API. O navegador fica com o cookie.

</details>

### Exercício 2

Um BFF repassa qualquer endereço que a página pedir. O que um script injetado consegue?

<details><summary>Uma boa resposta</summary>

Fazer o BFF mandar o access token da pessoa ao servidor do atacante. Por isso, o BFF só repassa a uma lista fixa de destinos.

</details>

## Fontes

- RFC 10017 (ago/2026), BCP 212, OAuth 2.0 for Browser-Based Applications: seções 5.1, 6.1 e 6.2
- draft-ietf-httpbis-layered-cookies-02 (mai/2026): o prefixo __Host-Http-
- RFC 6749 (out/2012), seção 2.1
- Laboratório: Keycloak 26.4 local e Edge 157
