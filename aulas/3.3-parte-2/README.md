# Aula 3.3, Parte 2: Refresh token, expiração e rotação

**No vídeo:** Usei o mesmo refresh token duas vezes: vida curta e rotação

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, o mesmo refresh token funcionou duas vezes. Com a rotação ligada, o reuso derrubou o login do app. Por quê?

Nesta parte você vê:
- os dois prazos da resposta do token;
- o ganho e o custo do access token de vida curta;
- o refresh token: onde vai e quanto vive;
- por que o client público precisa de rotação;
- a detecção de reuso, ao vivo no Keycloak.

## Reproduza

Os prazos da resposta, o refresh sem rotação, a rotação com o reuso e o access token de 10 s.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.3-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um access token de 24 horas vazou num log. O que limitaria o estrago? Pense em mais de uma mudança.

<details><summary>Uma boa resposta</summary>

Vida curta, de minutos, com o refresh token renovando. E, da Parte 1, o aud restrito a uma API e nada de token em log.

</details>

### Exercício 2

Com a rotação ligada, alguém copia o refresh token do app e usa primeiro. O que acontece quando o app tentar?

<details><summary>Uma boa resposta</summary>

O app manda um token que já virou velho. O servidor vê o reuso e derruba o login do app, com o par de quem copiou.

</details>

## Fontes

- RFC 9700 (IETF, jan/2025), seções 2.2.2 e 4.14
- RFC 6749 (IETF, out/2012), seções 1.5, 5.1, 6 e 10.4
- Keycloak: Server Administration Guide (conferido em 10/11/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
