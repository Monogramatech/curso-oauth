# Aula 9.3, Parte 1: act aninhado e may_act

**No vídeo:** Token exchange em cadeia: a claim act aninhada e o may_act

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Quem decide numa cadeia de tokens? Um token chegou com o estoque por fora e pedidos por dentro da claim act. Procurar pedidos em qualquer nível aceitaria; notas fiscais olhou só o ator atual, como pede a RFC 8693, e recusou (403).

Nesta parte você vê:
- o segundo salto e a claim act aninhada;
- quem decide: a pessoa e o ator atual;
- o may_act no token da pessoa;
- onde o may_act vale, e onde não.

## Reproduza

Dois saltos num servidor de troca mínimo: a act do primeiro vai dentro da act do segundo. Um token de serviço faz o papel do token da pessoa.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Chega a notas fiscais um token com três atores. Pagamentos por fora, o estoque no meio e pedidos no fundo.

<details><summary>Uma boa resposta</summary>

Quem decide o acesso, e notas fiscais emite a nota? Pausa e responde.

</details>

### Exercício 2

Pedidos pede a troca do token da pessoa só com o segredo, sem actor token. A claim de quem pode agir lista pedidos. Passa?

<details><summary>Uma boa resposta</summary>

Não passa. O servidor respondeu 400, porque faltou o sub.

</details>

## Fontes

