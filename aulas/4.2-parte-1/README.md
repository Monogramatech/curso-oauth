# Aula 4.2, Parte 1: Serviço falando com serviço, sem usuário

**No vídeo:** Client Credentials: quando o serviço pede o próprio token

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Client Credentials no laboratório: um job pediu o token com um POST só, sem navegador e sem pessoa. E o sub do token não era de ninguém.

Nesta parte você vê:
- o pedido, quem pode usar o fluxo e por que não há refresh token;
- o token sem pessoa: o sub da conta de serviço;
- grant × autenticação do client: segredo ou chave privada;
- o que se perde quando a ação é de uma pessoa.

## Reproduza

O job com segredo e, depois, com chave.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um job noturno recalcula o estoque; uma pessoa clica para gerar o próprio relatório. Qual pode usar client credentials sem perder informação?

<details><summary>Uma boa resposta</summary>

O job noturno, porque a ação é dele. No relatório, o sub seria de uma conta de serviço, e a API não saberia quem pediu.

</details>

### Exercício 2

Dois pedidos de token, os dois com o grant client credentials. Um leva o segredo no Basic; o outro, uma client assertion. O que muda?

<details><summary>Uma boa resposta</summary>

O que se pede é o mesmo; muda a prova. Com a assertion, o segredo não viaja, e neste servidor ela vale uma vez só.

</details>

## Fontes

- RFC 6749 (out/2012), seções 2.3.1 e 4.4 · RFC 9068 (out/2021), seção 2.2
- RFC 7523 (mai/2015) e RFC 10070 (nov/2026)
- OpenID Connect Core 1.0, seção 9 · RFC 9700 (jan/2025), seção 2.5
- Microsoft Learn, client credentials flow (13/11/2026)
- Laboratório: Keycloak 26.4 local
