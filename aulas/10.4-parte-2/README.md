# Aula 10.4, Parte 2: Transaction Tokens

**No vídeo:** Transaction Tokens: um token por transação no domínio

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Transaction Tokens: um serviço invadido mandou cobrar 990 reais com o token de transação da compra; o seguinte comparou com o contexto assinado (99 reais) e recusou.

Nesta parte você vê:
- a troca na entrada do domínio (RFC 8693, tipo txn_token);
- o mesmo token em todo salto, sem mudar;
- o token vazado e o de fora do domínio;
- troca por salto × token de transação.

## Reproduza

Um serviço de tokens mínimo e três serviços, sem Keycloak.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.4-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Como na Aula 7.2, um token vazou, agora um token de transação, ainda válido. O que quem o pegar consegue fazer?

<details><summary>Uma boa resposta</summary>

Só a mesma transação. O token não prova quem chama e vale no domínio todo: em pagamentos, que ainda não o tinha visto, passou.

</details>

### Exercício 2

Um domínio com 40 microsserviços. Troca por salto ou token de transação?

<details><summary>Uma boa resposta</summary>

Depende do que cada serviço precisa saber. Na cadeia medida, foram três trocas contra uma; a diferença cresce a cada salto da transação.

</details>

## Fontes

