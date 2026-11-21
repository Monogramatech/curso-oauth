# Aula 11.1, Parte 1: Identidade própria para o agente e o agente no act

**No vídeo:** Agente de IA com identidade própria: o agente no token

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Agente de IA com identidade própria: quando ele só repassa o token da pessoa, a API não o vê. Como cliente ou na troca, ele aparece no token, e dá para desligar só o agente.

Nesta parte você vê:
- o repasse × o agente como cliente × o agente na troca (claim do ator);
- uma regra que depende do ator (estorno pelo agente);
- o agente desligado no Keycloak, e o token que já existia;
- Entra Agent ID, Keycloak e o rascunho do WIMSE.

## Reproduza

Um servidor mínimo com o agente: o repasse, a troca, a regra do estorno e o agente desligado.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/11.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O agente recebe o token da Bia e chama as APIs com ele. Liste os problemas.

<details><summary>Uma boa resposta</summary>

A API não vê o assistente, porque o registro é igual ao da Bia. E nenhuma regra para agentes consegue valer.

</details>

### Exercício 2

A regra do estorno funciona em qual dos três desenhos?

<details><summary>Uma boa resposta</summary>

Nos dois em que o assistente aparece. Como cliente, e também na troca, o estorno levou 403, pedindo a confirmação.

</details>

## Fontes

