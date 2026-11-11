# Aula 3.2, Parte 1: Cabeçalho, payload, assinatura e as claims padrão

**No vídeo:** Dois tokens, o mesmo cabeçalho: a anatomia de um JWT

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, o access token e o ID token do mesmo login saíram com o cabeçalho idêntico, e um programa que confere assinatura, emissor e validade aceitou os dois. O que diferencia um do outro? Veja cada parte de um JWT, as claims padrão e o perfil de access token da RFC 9068.

Nesta parte você vê:
- as três partes (JWS) e o cabeçalho: alg, kid e typ;
- as sete claims registradas: iss, sub, aud, exp, nbf, iat e jti;
- o perfil da RFC 9068: typ at+jwt e as claims exigidas.

## Reproduza

Os dois tokens, o programa da 3.1 aceitando o ID token e o perfil da RFC 9068.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

No token novo, com at+jwt, decodificado na tela, para quem ele vale, em nome de quem e até quando?

<details><summary>Uma boa resposta</summary>

Vale para a API de fotos, em nome da pessoa do sub, até o exp, cinco minutos após o iat. O azp mostra o app que pediu.

</details>

### Exercício 2

Chega à API um token com typ application/at+jwt e aud com dois nomes, app de fotos e API de fotos. Ela aceita?

<details><summary>Uma boa resposta</summary>

No typ e no aud, passa. A forma longa também vale, e a API está na lista. Falta o resto: assinatura, emissor e tempo.

</details>

## Fontes

- RFC 7519 (IETF, mai/2015), seções 1, 2 e 4.1 a 4.3
- RFC 7515 (IETF, mai/2015), seções 3.1 e 4.1
- RFC 9068 (IETF, out/2021), seções 2.1, 2.2, 4 e 5
- OpenID Connect Core 1.0, seção 2
- Laboratório: Keycloak 26.4 local, nov/2026
