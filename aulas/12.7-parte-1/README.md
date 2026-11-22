# Aula 12.7, Parte 1: Entra e Keycloak: a ponte entre provedores (RFC 7523)

**No vídeo:** Entra e Keycloak: a ponte entre provedores (RFC 7523)

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Entra e Keycloak: o portal chamou um microsserviço de outro domínio com o token do Entra e levou 401. A ponte entre os dois provedores.

Nesta parte você vê:
- o JWT Authorization Grant (RFC 7523) no Keycloak 26.8;
- o token do Entra direto e as três concessões que ele pede;
- o sub de cada app e o oid;
- um STS de fronteira com a assertion no formato da RFC;
- reuso, audiência, prazo e escopo cobrados pelo Keycloak;
- o desenho completo e as outras saídas.

## Reproduza

Um emissor no formato do Entra, um STS e um receptor da RFC 7523 em Node, sem Docker.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.7-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O STS é um serviço a mais para manter. Por que não usar o token do Entra direto, se o Keycloak aceita?

<details><summary>Uma boa resposta</summary>

O direto desliga duas regras e prende a ligação a um app. O token pode entrar de novo, e a audiência fica fora do padrão.

</details>

### Exercício 2

A plataforma passa a atender o portal de uma segunda empresa, com outro tenant. O que muda na ponte?

<details><summary>Uma boa resposta</summary>

O STS confere se o tenant do token está numa lista. E a plataforma nunca deixa os dados de um tenant chegarem ao outro.

</details>

## Fontes

