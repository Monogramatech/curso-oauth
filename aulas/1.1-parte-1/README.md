# Aula 1.1, Parte 1: Base64url não é segurança: codificação, hash e cifra

**No vídeo:** Base64 não é criptografia: codificar, hash e cifra no JWT

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Base64 não é criptografia: este access token de 1.150 caracteres parece embaralhado, mas qualquer pessoa lê o conteúdo em segundos. Veja a diferença entre codificar, resumir e cifrar, com valores reais de um laboratório.

Nesta parte você vê:
- o token por dentro: cabeçalho, corpo e assinatura, e por que todo JWT começa com eyJ;
- como o Base64 funciona, e o que muda no Base64url;
- o hash SHA-256: tamanho fixo, mão única e uma letra que muda tudo;
- o hash no PKCE, recalculado com a troca real do laboratório;
- cifra simétrica (AES) e assimétrica (RSA), e onde a cifra entra no OAuth: o HTTPS;
- os três lado a lado, e a regra prática para o que vai dentro do token.

## Reproduza

Os comandos refazem as contas desta aula no seu terminal (Node 18 ou mais novo). Códigos, tokens e chaves vão sair diferentes dos da tela: são gerados a cada execução.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/1.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Decodifique T0s com a tabela da tela. Cada símbolo vale um número de 6 bits.

<details><summary>Uma boa resposta</summary>

Os três números juntam 18 bits. Os primeiros 16 formam dois bytes, e os dois bytes são as letras O e K.

</details>

### Exercício 2

Um colega guardou o CPF do usuário dentro do token, achando que o Base64url protege. Qual é o problema?

<details><summary>Uma boa resposta</summary>

Base64url não esconde nada. Qualquer um que pega o token decodifica o corpo e lê o CPF.

</details>

## Fontes

- RFC 4648, Base16, Base32 e Base64 (IETF, out/2006), seções 4 e 5
- RFC 7515, JSON Web Signature (IETF, mai/2015), seção 2 · RFC 7519, JSON Web Token (IETF, mai/2015)
- NIST FIPS 180-4, Secure Hash Standard (ago/2015)
- RFC 7636, PKCE (IETF, set/2015), seção 4.2
- NIST FIPS 197 (AES) e NIST SP 800-38D (GCM)
- RFC 8017, PKCS #1 v2.2 (RSA-OAEP) (IETF, nov/2016)
- RFC 6749 (IETF, out/2012), seções 3.1 e 3.2 · RFC 7516, JSON Web Encryption (IETF, mai/2015)
- Laboratório: Keycloak 26.4 local e Node 18 (node:crypto), nov/2026
