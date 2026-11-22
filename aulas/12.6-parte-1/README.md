# Aula 12.6, Parte 1: Device code na CLI e na TV: o golpe do código e as defesas

**No vídeo:** Device code na CLI e na TV: o golpe do código e as defesas

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Device code na CLI e na TV: a Bia aprovou um app verdadeiro, na página verdadeira, e o token foi para outra pessoa.

Nesta aula você vê:
- o device code (RFC 8628) na CLI sem navegador e na TV com QR;
- o golpe do código, medido de ponta a ponta;
- por que o prazo curto do código não basta;
- remover o acesso, o escopo mínimo e o acesso offline;
- os eventos e o alerta certo;
- onde ligar o device code, e o bloqueio no Entra ID.

Keycloak 26.4 no laboratório. Dois exercícios com pausa.

## Reproduza

Um servidor de device code mínimo em Node, sem Docker: o golpe, o token offline, a remoção do acesso e o escopo mínimo.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.6-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O código vale dez minutos. Se você reduzir para vinte segundos, o que acontece com o golpe?

<details><summary>Uma boa resposta</summary>

O código pronto vence antes. A Bia abriu o link vinte e cinco segundos depois, e a página disse: código vencido.

</details>

### Exercício 2

A equipe da CLI quer manter o device code para quem roda a CLI em servidores. O que você configura no Keycloak?

<details><summary>Uma boa resposta</summary>

Device code só no registro da CLI, escopo mínimo, sem acesso offline, e prazo curto. O custo: a CLI pede um código novo quando a sessão acaba.

</details>

## Fontes

