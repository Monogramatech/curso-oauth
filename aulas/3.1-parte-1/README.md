# Aula 3.1, Parte 1: Token opaco × JWT, e o token de portador (Bearer)

**No vídeo:** Token opaco ou JWT, e o que Bearer quer dizer

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, o servidor de autorização foi pausado, e um programa no papel da API conferiu o access token assim mesmo. Por quê? Veja o que é um token de portador (Bearer), como a API confere um JWT sozinha e por que um token opaco obriga a API a perguntar ao servidor.

Nesta parte você vê:
- Bearer: quem tem o token, usa;
- onde o token viaja: cabeçalho, corpo ou endereço, e o que a RFC 9700 proíbe;
- o JWT: os dados e a assinatura, conferidos sem chamar o servidor;
- o token opaco: uma referência aleatória que só o servidor entende.

## Reproduza

Token em outro programa, recusas, 403 sem openid, corpo do JWT, servidor pausado e valor opaco.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O log de um servidor gravou um endereço com o access token como parâmetro. Quem lê o log consegue o quê, e por quanto tempo?

<details><summary>Uma boa resposta</summary>

Quem lê o log chama a API como o app até o token expirar, mesmo se aquele pedido falhou. O token curto limita o estrago.

</details>

### Exercício 2

Opaco ou JWT? Milhares de chamadas por segundo. Um parceiro que vê o token, mas não pode ver o e-mail. Um acesso que acaba na hora.

<details><summary>Uma boa resposta</summary>

Um, JWT, sem consulta ao servidor. Dois, opaco, ou um JWT sem o e-mail. Três, opaco, que o servidor corta na próxima pergunta, ou JWT bem curto.

</details>

## Fontes

- RFC 6750 (IETF, out/2012), seções 1.2, 2.1 a 2.3, 3.1 e 5.3
- RFC 6749 (IETF, out/2012), seções 1.4 e 10.10
- RFC 9700 (IETF, jan/2025), seções 2.2.1 e 4.3.2
- RFC 7662 (IETF, out/2015)
- Microsoft Learn, "Access tokens"
- Google Cloud, "Token types"
- Laboratório: Keycloak 26.4 local, nov/2026
