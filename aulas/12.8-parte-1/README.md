# Aula 12.8, Parte 1: Agente de IA com ferramentas MCP: o token de cada salto

**No vídeo:** Agente de IA com ferramentas MCP: o token de cada salto

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Agente de IA com ferramentas MCP: o estorno não aparecia na tela do login da Bia, e um servidor MCP descuidado estornou o pedido dela assim mesmo.

Nesta parte você vê:
- o login no cliente MCP com o resource e a delegação;
- por que o servidor MCP se cadastra pelo próprio endereço;
- o segundo salto: repasse, credenciais do servidor e troca delegada;
- quem confere o que a pessoa permitiu, e a política do Keycloak que só deixa reduzir;
- o fim do curso.

## Reproduza

Um servidor mínimo em Node, sem Docker: o servidor MCP, a troca delegada, a API de pedidos e o servidor ingênuo.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.8-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A equipe quer simplificar e dar ao servidor MCP um token dele, que lê os pedidos de todo mundo. O que dá errado?

<details><summary>Uma boa resposta</summary>

O servidor passa a decidir sozinho de quem são os pedidos. Um agente enganado por um texto mostra os pedidos de outra pessoa.

</details>

### Exercício 2

Um segundo servidor MCP, de frete, de outra empresa, também quer a API de pedidos. Como você libera, sem abrir o estorno?

<details><summary>Uma boa resposta</summary>

Você não controla o código dele, então o limite vai no cadastro. Um cadastro próprio, com o endereço dele, e só a leitura da API.

</details>

## Fontes

