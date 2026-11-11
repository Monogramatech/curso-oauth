# Aula 0.1, Parte 1: Da senha compartilhada ao token delegado

**No vídeo:** O que é OAuth e por que ele existe: da senha ao token

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

O que é OAuth: até o fim dos anos 2000, muitos sites pediam a senha do seu e-mail para achar seus amigos, e guardavam essa senha. Veja por que isso era um desastre e a ideia que o OAuth trouxe no lugar: o token delegado.

Nesta parte você vê:
- os cinco problemas da senha emprestada, como a própria RFC 6749 lista;
- a chave de manobrista e o access token: destino, escopo, validade e revogação;
- quem autoriza: o login no site da rede social e a tela de consentimento;
- autenticação × autorização, e onde ficam o OAuth e o OpenID Connect;
- a linha do tempo: OAuth 1.0, OAuth 2.0, OpenID Connect, RFC 9700 e OAuth 2.1;
- para onde o curso vai: serviços e agentes de IA agindo em seu nome.

## Exercícios

### Exercício 1

Um app pede para ler sua agenda, um site confere sua senha, uma API recusa apagar um pedido. Qual é autenticação, e qual é autorização?

<details><summary>Uma boa resposta</summary>

Ler a agenda é autorização delegada, conferir a senha é autenticação, e recusar o pedido é autorização na API.

</details>

### Exercício 2

Um app guardou a sua senha, e outro recebeu um token só para ler fotos. Os dois vazam. O que o atacante consegue em cada caso?

<details><summary>Uma boa resposta</summary>

Com a senha, ele entra como você, em tudo, até você trocá-la. Com o token, ele só lê fotos, até o token expirar ou você revogar.

</details>

## Fontes

- RFC 6749, The OAuth 2.0 Authorization Framework (IETF, out/2012), seção 1: rfc-editor.org/rfc/rfc6749
- RFC 6750, Bearer Token Usage (IETF, out/2012)
- RFC 5849, The OAuth 1.0 Protocol (IETF, abr/2010)
- OpenID Connect Core 1.0 (OpenID Foundation, fev/2014)
- RFC 9700, Best Current Practice for OAuth 2.0 Security (IETF, jan/2025): rfc-editor.org/rfc/rfc9700
- OAuth 2.1: draft-ietf-oauth-v2-1 (IETF, em andamento)
