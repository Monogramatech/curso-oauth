# Aula 6.3, Parte 1: Mobile e desktop: navegador do sistema, esquemas de URL e loopback

**No vídeo:** OAuth em apps nativos: WebView, loopback e esquema próprio

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

OAuth em apps nativos: por que o login vai para o navegador do sistema, e não para uma WebView, e como o code volta ao app no celular, no computador e no terminal.

Nesta parte você vê:
- o app com WebView lendo a senha e copiando a sessão;
- o navegador do sistema: o app recebe só o code (RFC 8252);
- o retorno pela própria máquina: porta sorteada em 127.0.0.1 e state;
- qualquer porta, mas o mesmo caminho;
- o esquema próprio, o app falso e o que o PKCE barra (e o que não barra);
- o HTTPS reivindicado e o cofre do sistema.

## Reproduza

O cliente público com o retorno em 127.0.0.1 sem porta, uma linha de comando que escuta numa porta sorteada e as sondas de porta e caminho.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/6.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Por que fazer o login numa WebView, dentro do app, é um problema para a pessoa?

<details><summary>Uma boa resposta</summary>

O app lê a senha e copia a sessão. A pessoa não vê o endereço, e ainda entra de novo em cada app.

</details>

### Exercício 2

Uma linha de comando escuta em toda a rede, numa porta fixa, e não confere o state. O que pode dar errado?

<details><summary>Uma boa resposta</summary>

Outra máquina alcança a porta, outro programa pode pegá-la antes, e um retorno forjado entra. Escute só na própria máquina, porta sorteada, e confira o state.

</details>

## Fontes

- RFC 8252 (out/2017), BCP 212, OAuth 2.0 for Native Apps: seções 4 a 8
- RFC 9700 (jan/2025), BCP 240: seções 2.1, 2.2.2 e 2.6
- Apple Developer, Android Developers e Microsoft Learn (DPAPI), consultados em 16/11/2026
- Laboratório: Keycloak 26.4 local e Edge 157
