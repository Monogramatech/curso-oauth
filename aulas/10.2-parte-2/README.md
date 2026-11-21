# Aula 10.2, Parte 2: Os limites do OBO: por que ele não atravessa para outro domínio

**No vídeo:** On-behalf-of no Entra ID: cadeia, MFA e fronteira

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

On-behalf-of no Microsoft Entra ID, até onde ele vai: a API de pedidos pediu um token para a transportadora, que tem servidor próprio, e o emissor recusou. O on-behalf-of funciona dentro do tenant.

Nesta parte você vê:
- a cadeia longa e o azp que guarda só o último;
- o segundo fator no meio da cadeia: o desafio volta ao app;
- o atalho por client credentials, e por que não usar;
- a fronteira: confiança, audiência e um caminho que atravessa;
- a RFC 8693 no Entra: o que uma sondagem sem conta mostra.

## Reproduza

O Entra real, com um app inventado, e um emissor mínimo com a política do segundo fator.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O estoque pediu o segundo fator, e a API de pedidos tem permissão de serviço no estoque. Ela consegue seguir com client credentials? E deve?

<details><summary>Uma boa resposta</summary>

Consegue, mas não deve. No laboratório, o estoque respondeu 200, com doze unidades, e a resposta foi para o serviço.

</details>

### Exercício 2

A transportadora já confia no emissor da loja. A API de pedidos manda a ela o token da Bia. Passa? Se não, o que falta?

<details><summary>Uma boa resposta</summary>

Não passa. O aud é a API de pedidos, e o servidor recusou. Falta um token com a transportadora na audiência.

</details>

## Fontes

