# Aula 3.1, Parte 2: Introspecção e revogação

**No vídeo:** Revoguei o token, e a API aceitou: introspecção e revogação

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, o access token foi revogado: o servidor passou a responder inativo, mas a API que confere o JWT sozinha aceitou o mesmo token. Veja como a API pergunta ao servidor (introspecção), como o app revoga um token (revogação) e por que a revogação não alcança quem não pergunta.

Nesta parte você vê:
- a introspecção: a API pergunta, com credenciais próprias, e recebe active;
- a revogação: o app avisa o servidor, e o refresh token também se revoga;
- a janela do JWT conferido sozinho, e o que fazer: vida curta e introspecção onde importa.

## Reproduza

Client da API, introspecção, revogação do access token, o programa da parte 1 aceitando, refresh e revogação do refresh token.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app faz logout e revoga só o access token. O que ainda pode acontecer?

<details><summary>Uma boa resposta</summary>

O refresh token continua valendo, e quem o tiver pede access tokens novos. Revogue também o refresh token, e ninguém tira mais tokens dele.

</details>

### Exercício 2

Revogado às dez, um token vence às dez e quatro. Até quando a API que confere sozinha aceita? E com introspecção e cache de um minuto?

<details><summary>Uma boa resposta</summary>

Sozinha, até as dez e quatro, quando o token vence. Com introspecção, até as dez e um, no máximo, quando a resposta guardada vence.

</details>

## Fontes

- RFC 7662 (IETF, out/2015), seções 2.1, 2.2 e 4
- RFC 7009 (IETF, ago/2013), seções 2, 2.1, 2.2 e 3
- Keycloak, documentação 26.x (OIDC layers; Managing user sessions)
- Laboratório: Keycloak 26.4 local, nov/2026
