# Aula 5.2, Parte 1: As duas sessões e o logout pedido pelo app (RP-Initiated Logout)

**No vídeo:** Logout no OpenID Connect: por que sair do app não basta

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Logout no OpenID Connect: o laboratório apagou os tokens do app, como faz muito botão de sair, e o login seguinte entrou sem senha.

Nesta parte você vê:
- as duas sessões de um login: a do app e a do servidor;
- o endereço de logout na descoberta;
- o pedido de logout: o ID token como dica, o endereço de volta e o state;
- o que o servidor faz sem a dica e com ela;
- o que sobra de cada token depois do logout;
- o que o botão de sair precisa fazer.

## Reproduza

Sair só do app, o logout no servidor e os tokens depois.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/5.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A pessoa clicou em sair e, ao clicar em entrar, entrou sem digitar a senha. Por quê?

<details><summary>Uma boa resposta</summary>

O sair apagou só a sessão do app. A sessão do servidor continuou, e o servidor não pediu a senha.

</details>

### Exercício 2

Depois do sair, a pessoa vê uma página do servidor perguntando se quer mesmo sair. O que faltou no pedido do app?

<details><summary>Uma boa resposta</summary>

A dica, o ID token do login. Sem ela, a especificação manda perguntar. Com ela, perguntar é só recomendado, e este Keycloak não perguntou.

</details>

## Fontes

- OpenID Connect RP-Initiated Logout 1.0 (set/2022), seções 2, 2.1, 3 e 6
- OpenID Connect Discovery 1.0, errata set 2 (dez/2023), seção 4.3
- OpenID Connect Back-Channel Logout 1.0 (dez/2023), seção 2.7
- Laboratório: Keycloak 26.4 local
