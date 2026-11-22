# Aula 10.3, Parte 2: A troca na fronteira: quem aceita o token do outro lado

**No vídeo:** Token exchange no Cognito: ator, escopo e o token de fora

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Token exchange no Amazon Cognito, entre duas empresas: o portal trocou o token da Bia e o próprio por um token da transportadora com a claim do ator. Com a Carla, caiu: a troca não cria usuário.

Nesta parte você vê:
- o login federado que liga a pessoa de fora a um usuário do Cognito;
- a troca da RFC 8693 com e sem o ator (delegação × impersonificação);
- o escopo como interseção, a validade presa ao token da pessoa, sem refresh token;
- o token de fora e o usuário ligado, e o que a página ainda não diz;
- quem aceita o token do outro lado: Entra, STS, Cognito.

## Reproduza

O Cognito real, sem conta, e um servidor de troca mínimo com o ator, a interseção do escopo e o token de fora.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.3-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O token da Bia só tem o escopo de leitura. O portal pede leitura e cancelamento. O que o token novo traz?

<details><summary>Uma boa resposta</summary>

Pela documentação, só leitura. O Cognito cruza três listas: o escopo pedido, o do token da Bia e o que o app pode.

</details>

### Exercício 2

O que a Carla precisa para ganhar um usuário ligado, como a Bia no começo da aula?

<details><summary>Uma boa resposta</summary>

Entrar uma vez pelo login da loja, como a Bia. Ou o administrador cria o perfil e liga antes do primeiro login.

</details>

## Fontes

