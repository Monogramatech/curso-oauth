# Aula 11.2, Parte 1: O token expira no meio da tarefa

**No vídeo:** Token vencido no meio da tarefa do agente

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Token vencido no meio da tarefa do agente: na hora de pagar, a troca do token é recusada. Veja como renovar sem entregar o refresh token ao agente, e quando usar um token de tarefa.

Nesta parte você vê:
- a troca recusada com o token de origem vencido (RFC 8693);
- o refresh token preso ao portal, e a renovação pelo portal;
- o refresh token do próprio agente, preso à sessão (Keycloak);
- o token de tarefa, e o Keycloak 26.8, que corta a validade da troca;
- o logout da pessoa e o que sobra.

## Reproduza

Um servidor mínimo em Node, sem Docker: o token que vence, a troca recusada, a renovação e o token de tarefa.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/11.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Para o assistente renovar sozinho, o portal entrega a ele o próprio segredo e o refresh token. O que dá errado?

<details><summary>Uma boa resposta</summary>

O Keycloak passa a ver o portal, e não o assistente. É o repasse da Aula 11.1, agora com a renovação.

</details>

### Exercício 2

A tarefa leva duas horas, e a Bia pode sair no meio. Se ela sair, tudo tem de parar. O que você escolhe?

<details><summary>Uma boa resposta</summary>

Renove pela sessão, no portal ou no refresh token do assistente. No logout, a renovação acaba, e o último token vale só até vencer.

</details>

## Fontes

