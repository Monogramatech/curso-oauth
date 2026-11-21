# Aula 9.3, Parte 2: Downscoping por salto e permissão efetiva = usuário ∩ ator

**No vídeo:** Token exchange: o escopo de cada salto e a permissão efetiva

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

A troca de token pode dar ao serviço mais poder que a pessoa? No Keycloak 26.4, o token trocado ganhou um escopo que a pessoa não tinha e valeu 300 s, contra 120 s do dela. No servidor do curso, o mesmo pedido deu 400.

Nesta parte você vê:
- o escopo de cada salto: só pode perder;
- a validade: nunca além do token recebido;
- a permissão efetiva: a pessoa ∩ quem age;
- por que quem calcula não é o token.

## Reproduza

Servidor de troca mínimo com as duas regras do salto; um token de serviço faz o papel do da pessoa.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.3-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O token da pessoa vence aos 120 segundos. Aos 75, pedidos troca no servidor do curso, que dá 60. Quanto vale o token novo?

<details><summary>Uma boa resposta</summary>

45 segundos, e não 60. Aqui o token recebido é o da pessoa, e faltavam 45 para ele vencer.

</details>

### Exercício 2

A pessoa pode ler e escrever. O serviço que age por ela pode ler e apagar. Qual é a permissão efetiva?

<details><summary>Uma boa resposta</summary>

Só ler. Escrever, a pessoa pode, mas o serviço não. Apagar, o serviço pode, mas a pessoa não.

</details>

## Fontes

