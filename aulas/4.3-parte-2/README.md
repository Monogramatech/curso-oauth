# Aula 4.3, Parte 2: Implicit e Password: por que saíram

**No vídeo:** Implicit e Password: os fluxos que o OAuth aposentou

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Implicit e Password no laboratório: o token voltou dentro da URL, e outro app recebeu a senha da pessoa. Os dois fluxos saíram do OAuth 2.1.

Nesta parte você vê:
- por que o Implicit existiu e o token no fragmento da URL;
- o que a RFC 9700 aponta: histórico, retorno mal conferido, troca de token;
- o Password: a senha emprestada de volta ao app;
- o que o servidor perde sem a tela: consentimento e segundo fator;
- o que usar no lugar de cada um.

## Reproduza

O Implicit e o Password num laboratório local; os dois ficam desligados no fim.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.3-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app de celular pede usuário e senha numa tela própria e usa o Password. Cite duas coisas que o servidor deixa de fazer.

<details><summary>Uma boa resposta</summary>

O servidor não mostra o consentimento, nem a tela do segundo fator. E não sabe se o app guardou a senha.

</details>

### Exercício 2

Um app antigo usa o Implicit, e alguém cola o endereço da volta num chat. O fragmento não sai do navegador: o token está a salvo?

<details><summary>Uma boa resposta</summary>

Não. O fragmento não vai nas requisições, mas vai na cópia. Quem abrir o chat leva o token, por até 900 segundos.

</details>

## Fontes

- RFC 6749 (out/2012), seções 1.3.2, 1.3.3, 4.2, 4.3, 10.7 e 10.16
- RFC 9700 (jan/2025), seções 2.1.2, 2.4, 4.1 e 4.3
- OAuth 2.1, draft-ietf-oauth-v2-1-17 (31/10/2026), seção 10
- RFC 10017, OAuth 2.0 for Browser-Based Applications (ago/2026), seção 4
- Laboratório: Keycloak 26.4 local
