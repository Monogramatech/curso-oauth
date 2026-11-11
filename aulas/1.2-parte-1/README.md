# Aula 1.2, Parte 1: JWK, JWKS, kid e rotação de chaves

**No vídeo:** JWKS, kid e rotação de chaves: por que sua API recusou um token válido

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Um token com assinatura válida, recusado com 401. Veja onde a sua API encontra a chave pública que confere um JWT, como o kid aponta a chave certa no JWKS, e o que acontece quando o emissor troca de chave, com uma rotação real feita num laboratório com Keycloak.

Nesta parte você vê:
- o caminho até a chave: issuer, documento de descoberta (.well-known) e JWKS;
- o JWK por dentro: tipo, uso, algoritmo, kid, módulo, expoente e certificado (e por que só o tipo é obrigatório);
- o kid aponta, a assinatura prova;
- o cache de chaves por kid e quando buscar a lista de novo;
- a rotação passo a passo: chave nova, chave passiva e chave retirada;
- por que tirar uma chave da lista não tira dos caches na hora;
- confiar no issuer: HTTPS, a claim iss e por que o endereço da lista vem da configuração, nunca do token.

## Reproduza

Os comandos refazem a descoberta, o JWKS e a rotação de chave desta aula no seu laboratório. Códigos, tokens e chaves vão sair diferentes dos da tela: são gerados a cada execução.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/1.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A API recebe um token com um kid que não está no cache. O que ela faz?

<details><summary>Uma boa resposta</summary>

Busca a lista de novo, uma vez. Se o kid aparecer, confere a assinatura. Se não aparecer, recusa.

</details>

### Exercício 2

A chave antiga acabou de parar de assinar. Quando o emissor pode tirá-la da lista?

<details><summary>Uma boa resposta</summary>

Depois que vence o último token assinado com ela. No laboratório, o access token dura 300 segundos, então são pelo menos cinco minutos, com folga.

</details>

## Fontes

- RFC 7517, JSON Web Key (IETF, mai/2015), seções 4 e 5
- RFC 7515, JSON Web Signature (IETF, mai/2015), seções 4.1.2 e 4.1.4 · RFC 7518, seção 6.3
- OpenID Connect Discovery 1.0 e OpenID Connect Core 1.0 (errata 2, dez/2023), seções 10.1 e 10.1.1
- RFC 8725, JWT Best Current Practices (IETF, fev/2020), seções 3.8 e 3.10
- RFC 9068, JWT Profile for OAuth 2.0 Access Tokens (IETF, out/2021), seção 4
- Microsoft Learn: Signing key rollover in the Microsoft identity platform (consultado em nov/2026)
- Laboratório: Keycloak 26.4 local e Node 18 (node:crypto), nov/2026
