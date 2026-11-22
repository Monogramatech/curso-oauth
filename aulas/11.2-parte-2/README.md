# Aula 11.2, Parte 2: Aprovação humana: CIBA e step-up

**No vídeo:** Agente de IA pede aprovação no celular: CIBA e step-up

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Agente de IA pede aprovação no celular: a API exige autenticação recente para um estorno grande, e o agente pede a confirmação da pessoa pelo CIBA.

Nesta parte você vê:
- o desafio da RFC 9470 (401, autenticação insuficiente);
- o CIBA no Keycloak: o pedido, o celular, a consulta e o token;
- a aprovação que não fica presa ao estorno;
- negar, cancelar e o pedido que vence.

## Reproduza

Um servidor mínimo em Node, sem Docker: o desafio, o pedido de CIBA e você no papel da Bia.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/11.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Por que a Bia não confirma na tela do próprio assistente?

<details><summary>Uma boa resposta</summary>

O rascunho dos agentes exige que a confirmação esteja presa a uma autorização verificável, que o servidor de autorização emite.

</details>

### Exercício 2

Desenhe a política para um agente que reembolsa compras acima de um valor.

<details><summary>Uma boa resposta</summary>

Abaixo do valor, o token do dia a dia basta. Acima, vem o desafio, e o agente pede a confirmação pelo CIBA, com o valor na mensagem.

</details>

## Fontes

