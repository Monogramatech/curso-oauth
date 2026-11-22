# Aula 10.3, Parte 1: O que o AWS STS emite (e o que não emite)

**No vídeo:** AWS STS: o que ele emite (credenciais, JWT e a pessoa)

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

AWS STS por dentro: o portal pediu um JWT para chamar a transportadora em nome da Bia, e o sub do token é a função do portal. No caminho, a pessoa virou uma credencial da AWS.

Nesta parte você vê:
- o ID token trocado por uma credencial temporária, e o que vai dentro dela;
- a assinatura de cada pedido, e por que a credencial não tem audiência;
- o JWT da conta para fora (federação de saída) e a transportadora conferindo;
- o modo novo que põe a pessoa no sub (novembro de 2026);
- o que falta no STS para a troca da RFC 8693.

## Reproduza

O STS real, sem conta, e um STS mínimo com o modo de identidade de origem.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O portal mandou as três partes da credencial para a transportadora. O que ela consegue fazer com elas?

<details><summary>Uma boa resposta</summary>

Tudo o que a função do portal pode, até a credencial vencer. No laboratório, a transportadora assinou o pedido e leu o arquivo.

</details>

### Exercício 2

Liste o que falta no STS da AWS para fazer essa troca, com a pessoa e o ator.

<details><summary>Uma boa resposta</summary>

Falta o pedido da RFC 8693, com os tokens da pessoa e do ator. Falta a claim do ator e o escopo preso ao token da pessoa.

</details>

## Fontes

