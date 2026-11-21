# Aula 10.1, Parte 1: Trust domains e JWT como grant (RFC 7523)

**No vídeo:** RFC 7523: JWT como grant e no lugar do segredo do client

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Um JWT chegou ao domínio B com o emissor e o kid do domínio A, mas assinado com outra chave. B recusou: confiar num emissor é confiar nas chaves que ele publica.

Nesta parte você vê:
- dois domínios e a lista de confiança;
- o JWT de A trocado por um token de B (RFC 7523, 2.1);
- audiência, validade e reuso da asserção;
- o JWT assinado no lugar do segredo (2.2).

## Reproduza

Um domínio B mínimo que confia no realm curso e aceita o JWT dele como pedido de token.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um serviço de A pega um token emitido para a API de pedidos do próprio domínio A e o apresenta a B. A assinatura confere.

<details><summary>Uma boa resposta</summary>

O domínio B aceita? Pausa e responde.

</details>

### Exercício 2

O domínio B quer aceitar tokens do domínio A. O que precisa estar combinado e configurado?

<details><summary>Uma boa resposta</summary>

Uma boa resposta, pela seção 5 da RFC: o emissor e a audiência. Também o endereço onde se pede o token e a chave que confere a assinatura.

</details>

## Fontes

