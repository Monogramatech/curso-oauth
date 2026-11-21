# Aula 10.4, Parte 1: Identity chaining across domains

**No vídeo:** Identity chaining: token exchange e JWT entre domínios

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Identity chaining: numa troca, o Keycloak da loja emitiu um JWT só para a transportadora, que o aceitou; na outra, ele caiu.

Nesta parte você vê:
- as duas trocas do rascunho da IETF (RFC 8693 e 7523);
- a concessão no Keycloak 26.4;
- o domínio B: a pessoa, sem refresh token;
- o atalho com o token da pessoa.

## Reproduza

Uma troca no Keycloak e uma transportadora mínima.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.4-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O token da transportadora vence em 5 minutos, e não veio refresh token. Como a API de pedidos consegue outro?

<details><summary>Uma boa resposta</summary>

Volta ao domínio A, com um token da Bia ainda válido. A concessão também vence em 300 segundos, e a mesma de novo deu 400.

</details>

### Exercício 2

A transportadora só tem a troca, sem o JWT como pedido. O que a loja manda, para não entregar o token dos pedidos?

<details><summary>Uma boa resposta</summary>

A concessão, como subject token. Ela tem a audiência da transportadora, que conferiu e aceitou.

</details>

## Fontes

