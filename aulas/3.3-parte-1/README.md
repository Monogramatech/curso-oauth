# Aula 3.3, Parte 1: aud e scope: destino e poder

**No vídeo:** Um token, duas APIs: aud e scope, destino e poder

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, um pedido com dois escopos gerou um token só, com as duas APIs no aud. Por que o certo é um token por API?

Nesta parte você vê:
- aud e scope: as duas perguntas que a API faz;
- como o escopo pedido põe a API no aud (Keycloak);
- o risco do token com vários destinos;
- o parâmetro resource da RFC 8707.

## Reproduza

Dois destinos, um token por escopo, um com os dois, o refresh token com escopo menor e o resource da RFC 8707.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um token com as duas APIs no aud vai parar no log da API de fotos. Qual o risco, e o que mudar?

<details><summary>Uma boa resposta</summary>

Quem lê o log chama também a API de pagamentos. A saída é um token por API, com aud restrito, e nada de token em log.

</details>

### Exercício 2

A API de pagamentos recebe um token com as duas APIs no aud, mas só com o escopo fotos publicar. Ela lista os pagamentos?

<details><summary>Uma boa resposta</summary>

Não. Ela está no aud, então passa na primeira pergunta. Mas falta o escopo pagamentos ler, e ela recusa na segunda.

</details>

## Fontes

- RFC 9700 (IETF, jan/2025), seções 2.3 e 4.9.3
- RFC 8707 (IETF, fev/2020), seções 1 a 3
- RFC 6749 (IETF, out/2012), seção 6
- RFC 9068 (IETF, out/2021), seção 2.2.3
- Microsoft Learn: Scopes and permissions (conferido em 10/11/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
