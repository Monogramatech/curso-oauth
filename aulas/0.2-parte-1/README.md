# Aula 0.2, Parte 1: Um clique em "Entrar com…", passo a passo

**No vídeo:** Como funciona o "Entrar com…": o fluxo OAuth passo a passo

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Como funciona o "Entrar com…": você clica no botão e o navegador abre um endereço com sete parâmetros. Siga esse clique até o fim, em seis passos, com as requisições reais de um laboratório com Keycloak.

Nesta parte você vê:
- os personagens: dono do recurso, cliente, servidor de autorização e API;
- o pedido de autorização e o que cada parâmetro faz, PKCE incluído;
- o login no servidor e a tela de consentimento;
- o código que volta pelo navegador, e por que ele não é o token;
- a troca do código pelo token, pelo canal de trás, e os campos da resposta;
- a chamada à API com Bearer, e o 401 sem token;
- o mapa do curso: que módulo aprofunda cada peça.

## Reproduza

Esta parte monta o laboratório que o curso inteiro usa:

```bash
bash laboratorio/preparo.sh
bash laboratorio/login.sh
```

## Exercícios

### Exercício 1

O código de autorização passou pelo navegador. Por que isso não basta para um atacante chamar a API?

<details><summary>Uma boa resposta</summary>

O código não é o token. Ele vale uma vez, por pouco tempo, e a troca exige o code_verifier, que só o app tem.

</details>

### Exercício 2

Na tela, os seis passos estão embaralhados. Coloque na ordem certa.

<details><summary>Uma boa resposta</summary>

Redirecionamento, login, consentimento, retorno com o código, troca pelo token e chamada à API.

</details>

## Fontes

- RFC 6749, The OAuth 2.0 Authorization Framework (IETF, out/2012), seções 4.1 e 5.1
- RFC 7636, Proof Key for Code Exchange (PKCE) (IETF, set/2015)
- RFC 9207, Authorization Server Issuer Identification (IETF, mar/2022)
- RFC 6750, Bearer Token Usage (IETF, out/2012), seções 2.1 e 3
- OpenID Connect Core 1.0 (OpenID Foundation), seções 2 e 5.3
- Laboratório: Keycloak 26.4 local (quay.io/keycloak/keycloak:26.4), nov/2026
