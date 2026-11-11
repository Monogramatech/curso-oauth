# Aula 2.2, Parte 1: Cliente público × confidencial, client_id, redirect_uri

**No vídeo:** Client público × confidencial e o redirect_uri exato

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, bastou uma barra a mais no fim do endereço de retorno cadastrado: o servidor recusou o login e nem devolveu o navegador ao app. Veja o que o authorization server sabe de cada app, quais apps guardam segredo e por que o endereço de retorno é comparado caractere por caractere.

Nesta parte você vê:
- o registro do client: client_id, endereços de retorno, nome e, às vezes, um segredo;
- client confidencial × público, e por que um app de celular não guarda segredo;
- o segredo no endpoint de token: 401 sem ele, 200 com o Basic;
- o PKCE, e o ataque que só o endereço exato barra;
- o redirect_uri comparado no pedido e na troca;
- o registro no painel e o registro dinâmico (RFC 7591).

## Reproduza

Os comandos criam um client confidencial, trocam um code sem e com o segredo, testam a barra a mais e registram um client por API. Os valores saem diferentes dos da tela.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/2.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app de celular pode ter client secret?

<details><summary>Uma boa resposta</summary>

Até pode receber um, mas não consegue guardar. Qualquer um extrai do pacote. Para o OAuth, ele é público, e conta com o PKCE.

</details>

### Exercício 2

O app registrou o endereço de retorno da tela. Dos quatro pedidos, quais o servidor aceita?

<details><summary>Uma boa resposta</summary>

Só o primeiro, idêntico ao registrado. A barra a mais, o host parecido e o outro caminho, o servidor recusa.

</details>

## Fontes

- RFC 6749 (IETF, out/2012), seções 2.1 a 2.3.1, 3.1.2, 4.1.2.1, 4.1.3, 5.2 e 10.6
- RFC 9700 (IETF, jan/2025), seções 2.1, 2.1.1, 4.1 e 4.1.1
- RFC 8252 (IETF, out/2017), seções 7.3, 8.3 e 8.5
- RFC 7591 (IETF, jul/2015), seção 3
- Microsoft Learn: registro de aplicativos no Entra ID (nov/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
