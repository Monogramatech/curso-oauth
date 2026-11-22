# Aula 6.1, Parte 1: Back-end web clássico: sessão por cookie e tokens no servidor

**No vídeo:** Cookie de sessão HttpOnly e SameSite: o app web com servidor

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Cookie de sessão HttpOnly e SameSite: num app web com servidor, os tokens ficam no servidor, e um script na página não acha nem a sessão nem os tokens.

Nesta parte você vê:
- o app com servidor como cliente confidencial, com segredo e PKCE;
- a troca do code pelo canal de trás;
- a tabela de sessões e o cookie que vai ao navegador;
- HttpOnly, Secure e SameSite, medidos num navegador de verdade;
- o POST de outro site (CSRF) e a navegação com GET;
- o que um script injetado (XSS) ainda consegue fazer.

## Reproduza

O app confidencial, a troca com o segredo e o cookie HttpOnly no navegador.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/6.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O app marcou o cookie de sessão sem HttpOnly. O que um script injetado ganha com isso?

<details><summary>Uma boa resposta</summary>

O valor da sessão. O script manda o cookie para fora, e o atacante usa a sessão de outro computador, até ela acabar.

</details>

### Exercício 2

O botão de apagar receita usa um link com GET, e o cookie é Lax. Um outro site consegue apagar a receita?

<details><summary>Uma boa resposta</summary>

Consegue. O Lax deixa o cookie ir na navegação de topo com GET. Por isso a ação vai por POST.

</details>

## Fontes

- RFC 6749 (out/2012), seções 2.1, 2.3.1 e 10.4
- RFC 6265 (abr/2011), seções 4.1.2.5, 4.1.2.6 e 8.5
- draft-ietf-httpbis-rfc6265bis-22 (dez/2025), seções 4.1.2.7 e 5.6.7.1
- RFC 9700 (jan/2025), seções 2.1.1 e 2.2.2
- Laboratório: Keycloak 26.4 local e Edge 157
