# Aula 4.1, Parte 3: PKCE por dentro: code_verifier, code_challenge e S256

**No vídeo:** PKCE por dentro: a conta do S256 e o método plain

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

PKCE com o método plain: no laboratório, quem leu o endereço do pedido e o de retorno recebeu os tokens.

Nesta parte você vê:
- por que o plain entrega o verifier;
- a conta do S256, com o exemplo da RFC 7636;
- o que o servidor guarda e compara na troca;
- o que ele confere, e o que não;
- o rebaixamento do PKCE.

## Reproduza

A conta do S256 e cada caso da tela, com logins de verdade.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.1-parte-3/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O servidor guardou o desafio e o método S256. Na troca, alguém manda o próprio desafio no lugar do verifier. O que o servidor faz?

<details><summary>Uma boa resposta</summary>

Ele calcula o hash do valor que chegou, em Base64url. O resultado não bate com o desafio guardado: invalid grant. Copiar o desafio não adianta.

</details>

### Exercício 2

Um app calcula o desafio com S256, mas esquece o parâmetro do método. O servidor não exige S256 desse client. O que acontece na troca?

<details><summary>Uma boa resposta</summary>

Sem o parâmetro, vale o plain. O servidor compara o verifier direto com o desafio, que é um hash. Não são iguais: invalid grant.

</details>

## Fontes

- RFC 7636 (IETF, set/2015), seções 1, 4 e 7 e apêndice B
- RFC 9700 (IETF, jan/2025), seções 2.1.1 e 4.8
- Keycloak: Server Administration Guide (conferido em 11/11/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
