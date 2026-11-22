# Aula 12.2, Parte 1: Login no Next.js com BFF: onde ficam os tokens

**No vídeo:** Login no Next.js com BFF: onde ficam os tokens

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Login no Next.js com BFF e uma API própria, de ponta a ponta: onde a biblioteca de login guarda os tokens e quatro erros medidos.

Nesta aula você vê:
- o client confidencial e a API que só aceita o próprio token;
- os tokens num cookie cifrado de 4 KB, em dois pedaços;
- o access token entregue à página pelo exemplo da documentação;
- o cache do fetch no Next.js 14;
- a renovação no servidor e o sair que avisa o Keycloak.

Next.js 14.2 e next-auth 4 de verdade, no laboratório. Dois exercícios com pausa.

## Reproduza

Um BFF mínimo em Node, sem Docker: a sessão num cookie cifrado, a renovação e o cookie copiado antes do sair.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Decida se os tokens dentro do cookie cifrado contrariam o BFF da RFC.

<details><summary>Uma boa resposta</summary>

A RFC aceita a sessão guardada no próprio cookie. Para cortar o acesso, basta revogar o access token ou o refresh token.

</details>

### Exercício 2

A equipe quer que o sair derrube na hora até o cookie copiado. O que muda no desenho?

<details><summary>Uma boa resposta</summary>

A sessão fica no servidor, e o cookie leva só um identificador. O sair apaga a sessão, e o cookie copiado não serve mais.

</details>

## Fontes

