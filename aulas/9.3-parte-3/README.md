# Aula 9.3, Parte 3: Rastreabilidade: txn, logs de troca e auditoria

**No vídeo:** Token exchange: rastreabilidade com txn e limite da cadeia

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Duas cobranças de 99 reais, o mesmo pedido, a mesma pessoa e o mesmo ator: uma não devia existir. O token não diz qual; o identificador de transação (txn) diz.

Nesta parte você vê:
- o que a claim do ator não diz;
- o txn assinado, criado na 1ª troca;
- o registro de cada troca;
- o limite de atores na cadeia.

## Reproduza

Servidor de troca mínimo com o txn e o limite de 3 atores; um token de serviço faz o papel do da pessoa.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.3-parte-3/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Imagine que a auditoria juntasse as cobranças pelo cabeçalho de correlação, e não pelo identificador de transação do token.

<details><summary>Uma boa resposta</summary>

Alguma cobrança ficaria sem pedido, e onde cairia a terceira? Pausa e responde.

</details>

### Exercício 2

Com o token de três atores, estoque, pagamentos e pedidos, pagamentos precisa chamar notas fiscais, numa chamada legítima. Será que o servidor deixa?

<details><summary>Uma boa resposta</summary>

O servidor recusa. A cadeia ficaria com quatro atores, e ele respondeu 400, a mesma resposta da volta ao estoque.

</details>

## Fontes

