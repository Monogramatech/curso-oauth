# Aula 7.1, Parte 1: Validar token em toda requisição: middleware, cache de JWKS, erros 401 e 403

**No vídeo:** Validar token na API: middleware, cache de JWKS, 401 e 403

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Como a API valida o access token em todo pedido: o middleware, o cache das chaves e as respostas 401 e 403.

Nesta parte você vê:
- o middleware antes da rota;
- o token na URL e o log;
- três caches de JWKS: troca de chave, kid inventado, chave que sai;
- 401, 403 e o WWW-Authenticate;
- os metadados da API (RFC 9728).

## Reproduza

Um client de serviço, a API de uma linha, os pedidos com e sem escopo, e a troca de chave.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/7.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A sua API responde 403 quando o token vence. O que o cliente faz de errado por causa disso?

<details><summary>Uma boa resposta</summary>

Ele não renova, porque 403 diz que renovar não resolve. A pessoa fica sem acesso, quando bastava renovar. O certo é 401, com invalid token.

</details>

### Exercício 2

Alguém manda mil tokens por minuto, cada um com um kid inventado. O que a sua API faz, e o que ela não pode fazer?

<details><summary>Uma boa resposta</summary>

Recusa todos com 401. Busca o JWKS no máximo uma vez por intervalo, nunca uma vez por token, senão quem sofre é o Keycloak.

</details>

## Fontes

- RFC 6750 (out/2012), seções 2, 3 e 3.1; RFC 9110 (jun/2022), seções 15.5.2 e 15.5.4
- RFC 9068 (out/2021), seção 4; RFC 8414 (jun/2018), seção 3.3
- RFC 9700 (jan/2025), seções 2.3 e 4.3.2; RFC 9728 (abr/2025), seções 2, 3, 5 e 7
- MCP, especificação 2026-07-28, consultada em 16/11/2026
