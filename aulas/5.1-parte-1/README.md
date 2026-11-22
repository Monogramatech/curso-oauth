# Aula 5.1, Parte 1: O que o OIDC acrescenta: escopo openid, ID token, UserInfo

**No vídeo:** OpenID Connect na prática: o ID token e o userinfo

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

OpenID Connect no laboratório: o mesmo login, mudando uma palavra no escopo, trouxe um token a mais, o que diz ao app quem entrou.

Nesta parte você vê:
- por que o OAuth não diz quem entrou, e o escopo openid;
- o ID token por dentro: iss, aud, sub, auth_time, acr e nonce;
- por que guardar a pessoa por emissor e sub, e não pelo e-mail;
- o userinfo e os escopos de perfil (profile e email);
- o destino de cada token: o ID token para o app, o access token para a API.

## Reproduza

O mesmo login com e sem openid, e o ID token decodificado.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/5.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app pede só openid e quer mostrar o nome da pessoa. O userinfo resolve?

<details><summary>Uma boa resposta</summary>

Não. Só com openid, o userinfo devolve o sub e mais nada. Para o nome, o app pede também o profile.

</details>

### Exercício 2

O ID token tem a assinatura certa e o aud do app. Mas o nonce não é o que o app mandou. O app aceita?

<details><summary>Uma boa resposta</summary>

Não. Assinatura e aud certos dizem que o token é do servidor e para o app, mas não deste pedido. O app recusa.

</details>

## Fontes

- OpenID Connect Core 1.0, errata set 2 (OpenID Foundation, dez/2023), seções 1, 2, 3.1.2.1, 3.1.3.6, 3.1.3.7, 5.1, 5.3, 5.4 e 5.7
- Laboratório: Keycloak 26.4 local
