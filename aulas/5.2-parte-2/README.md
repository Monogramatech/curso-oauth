# Aula 5.2, Parte 2: Avisar os outros apps: front-channel e back-channel logout

**No vídeo:** Front-channel e back-channel logout: avisar os outros apps

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Front-channel e back-channel logout: a pessoa saiu de um app, e o servidor avisou os outros dois, um pelo navegador e outro direto, com um logout token.

Nesta parte você vê:
- por que a sessão de cada app continua depois do logout;
- o canal da frente: o iframe com o iss e o sid;
- por que ele depende da aba aberta e dos cookies;
- o canal de trás: o logout token, sem nonce e com events;
- como o app confere o logout token e apaga a sessão;
- qual canal usar.

## Reproduza

O logout token chegando ao back-end do app de notas.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/5.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app que não exige o sid recebe um logout token válido, com o sub e sem o sid. O que ele encerra?

<details><summary>Uma boa resposta</summary>

Todas as sessões dessa pessoa no app. Sem o sid, a especificação diz que valem o emissor e o sub.

</details>

### Exercício 2

Um app que roda só no navegador, sem servidor próprio, quer saber do logout. Que canal ele pode usar, e com que risco?

<details><summary>Uma boa resposta</summary>

Dos dois canais, só o da frente, porque o servidor não alcança o app. Os riscos: a aba fechar antes e o navegador esconder a sessão.

</details>

## Fontes

- OpenID Connect Front-Channel Logout 1.0 (set/2022), seções 2, 3 e 4.1
- OpenID Connect Back-Channel Logout 1.0, errata 1 (dez/2023), seções 1, 2.1 a 2.8, 4 e 4.1
- RFC 8725 (fev/2020), seção 3.11
- Laboratório: Keycloak 26.4 local
