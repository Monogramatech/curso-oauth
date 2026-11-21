# Aula 9.2, Parte 2: Impersonificação × delegação

**No vídeo:** Impersonificação × delegação na troca de token: a claim act

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Impersonificação ou delegação? No laboratório, pedidos trocou duas vezes o mesmo token da pessoa. Sem actor token, pagamentos recusou (403); com ele, o token ganhou a claim act e a cobrança passou (201).

Nesta parte você vê:
- a impersonificação da RFC 8693 e a troca padrão do Keycloak 26.4;
- a delegação: o actor token, a claim act e a auditoria;
- o que o servidor de troca confere no ator.

## Reproduza

A troca sem e com actor token e duas recusas, num servidor de troca mínimo. Um token de serviço faz o papel do token da pessoa.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O estoque pede uma troca com o próprio segredo e o próprio actor token. O subject token é o que a pessoa deu a pedidos. Passa?

<details><summary>Uma boa resposta</summary>

Não passa. O servidor respondeu 400: o estoque não está na audiência do token da pessoa.

</details>

### Exercício 2

Três tokens. O primeiro traz a pessoa e o azp pedidos. O segundo, a pessoa e a claim do ator. O terceiro, só a conta de serviço.

<details><summary>Uma boa resposta</summary>

Qual é impersonificação, qual é delegação, e qual não é nenhum dos dois? Pausa e responde.

</details>

## Fontes

