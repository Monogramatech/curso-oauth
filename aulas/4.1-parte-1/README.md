# Aula 4.1, Parte 1: O fluxo completo, requisição por requisição

**No vídeo:** Authorization Code completo: quem manda cada requisição

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Authorization Code, requisição por requisição: no laboratório, um login levou seis requisições ao servidor, e o app mandou só duas.

Nesta parte você vê:
- quem manda cada requisição: o navegador ou o app;
- o que o app guarda antes do clique e confere na volta;
- o que o servidor confere na troca do code;
- por que, no segundo login, o navegador faz uma requisição só;
- o code usado duas vezes: o servidor recusa os tokens;
- os três lugares onde um erro de login aparece.

## Reproduza

O login com o F12 aberto, o code repetido, o segundo login, as conferências da troca e os erros.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Das seis requisições, em qual o code vira token? E quem manda essa requisição?

<details><summary>Uma boa resposta</summary>

Na quinta, o POST no endpoint de token. Quem manda é o app, direto, pelo canal de trás. Nada passa pela barra de endereço.

</details>

### Exercício 2

O login de um app novo falha. A pessoa vê uma página de erro do servidor, sem voltar ao app. O que você confere primeiro?

<details><summary>Uma boa resposta</summary>

O client id e o endereço de retorno do pedido, comparados com o registro. No laboratório, a própria página dizia qual parâmetro estava errado.

</details>

## Fontes

- RFC 6749 (IETF, out/2012), seções 3.1, 4.1 e 5.2
- RFC 9207 (IETF, mar/2022), seção 2.4
- RFC 7636 (IETF, set/2015), seção 4.4
- Keycloak: Server Administration Guide (conferido em 11/11/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
