# Aula 1.1, Parte 2: Assinatura digital: HMAC × chave pública

**No vídeo:** Assinatura de JWT: HS256 × RS256, quem precisa de qual chave

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Um token forjado pela própria API que deveria conferi-lo, e a assinatura confere. Veja como um JWT é assinado, a diferença entre HMAC (HS256) e chave pública (RS256 e ES256), e quem precisa de qual chave para conferir um token, com valores reais de um laboratório.

Nesta parte você vê:
- o que uma assinatura garante (integridade e origem) e o que ela não garante (sigilo);
- o que entra na conta: o cabeçalho e o corpo, com o ponto no meio;
- HMAC e HS256: o mesmo segredo assina e confere, e por que quem confere pode fabricar;
- onde o HMAC serve: o refresh token do Keycloak, assinado com HS512;
- RS256 e ES256: a chave privada assina, a pública só confere;
- o access token real conferido com a chave pública do JWKS;
- Entra ID, Cognito e a regra do algoritmo esperado.

## Reproduza

Os comandos refazem as assinaturas desta aula no seu terminal (Node 18 ou mais novo). Códigos, tokens e chaves vão sair diferentes dos da tela: são gerados a cada execução.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/1.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um servidor de autorização e três APIs usam HS256 com o mesmo segredo. Um atacante invade uma das APIs. O que ele consegue fazer?

<details><summary>Uma boa resposta</summary>

Ele leva o segredo e emite tokens válidos, com qualquer usuário e qualquer escopo, que as outras duas APIs aceitam.

</details>

### Exercício 2

Quem precisa de qual chave para conferir um token RS256? E quem pode receber a chave privada?

<details><summary>Uma boa resposta</summary>

O emissor guarda a privada e assina. As APIs recebem só a pública, do JWKS, e conferem. A privada não sai do emissor para ninguém.

</details>

## Fontes

- RFC 2104, HMAC (IETF, fev/1997)
- RFC 7515, JSON Web Signature (IETF, mai/2015), seção 5.1
- RFC 7518, JSON Web Algorithms (IETF, mai/2015), seções 3.1 a 3.4 e 6.3
- RFC 8017, PKCS #1 v2.2 (IETF, nov/2016) · RFC 7517, JSON Web Key (IETF, mai/2015)
- NIST FIPS 186-5 (fev/2023) · NIST SP 800-57 Parte 1, rev. 5 (mai/2020)
- Microsoft Learn: Access tokens in the Microsoft identity platform (consultado em nov/2026)
- AWS: Verifying JSON web tokens, Amazon Cognito (consultado em nov/2026)
- Laboratório: Keycloak 26.4 local e Node 18 (node:crypto), nov/2026
