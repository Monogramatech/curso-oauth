# Aula 10.2, Parte 1: Claims do Entra (oid, tid, grupos, papéis) e o fluxo On-Behalf-Of

**No vídeo:** Entra ID por dentro: oid, tid, roles e on-behalf-of

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Microsoft Entra ID por dentro: uma API conferiu a assinatura, o emissor e a audiência de um token no formato do Entra e entregou os pedidos da loja a uma pessoa de outra empresa. O token era válido; só vinha de outro tenant.

Nesta parte você vê:
- o emissor com {tenantid} e o tid contra a lista da API;
- sub par a par × oid: a pessoa é o par tid e oid;
- scp × roles, grupos × perfis do app e o token de app;
- a regra ingênua (tid + oid) que deixa qualquer serviço entrar;
- o on-behalf-of: o pedido, o que muda no token e o consentimento;
- as recusas do on-behalf-of.

## Reproduza

O documento público do Entra e um emissor mínimo do curso com o on-behalf-of e a regra do aud.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app guarda as preferências pelo sub. A empresa troca esse app por outro, com registro novo. O que acontece com elas?

<details><summary>Uma boa resposta</summary>

O app novo recebe outro sub para as mesmas pessoas, e as preferências ficam órfãs. Guardadas pelo par tid e oid, continuariam lá.

</details>

### Exercício 2

A API de pedidos recebeu este token, com o aud do estoque. Ela pode usá-lo num on behalf of?

<details><summary>Uma boa resposta</summary>

A API de pedidos não pode. O token é do estoque, e só o app do aud pode trocá-lo. O laboratório deu 400.

</details>

## Fontes

