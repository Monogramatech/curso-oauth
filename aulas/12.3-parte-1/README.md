# Aula 12.3, Parte 1: Refresh token no app de celular: o login que dura semanas

**No vídeo:** Refresh token no app de celular: o login que dura semanas

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Refresh token num app de celular com API própria: o suporte trocou a senha, e o app no celular perdido continuou entrando.

Nesta aula você vê:
- refresh token comum × token offline;
- três telas com o token vencido derrubando o login;
- uma renovação por vez, no código do app;
- a resposta perdida e o limite de reuso;
- o que corta o acesso do celular perdido.

Keycloak 26.4 no laboratório. Dois exercícios com pausa.

## Reproduza

Emissor mínimo em Node, sem Docker: rotação, as duas renovações do app e o Sair que revoga.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O app tem uma tarefa em segundo plano que também renova o token, num processo separado. Decida o que pode dar errado.

<details><summary>Uma boa resposta</summary>

A variável da renovação só vale dentro de um processo. A tarefa renova sozinha, com o mesmo token, e o reuso derruba o login.

</details>

### Exercício 2

O botão Sair do app abre o logout no navegador do sistema e limpa os tokens do celular. Decida se falta alguma coisa.

<details><summary>Uma boa resposta</summary>

Falta revogar o token offline no Keycloak. O logout no navegador nem sempre corta esse token, e a revogação corta sempre.

</details>

## Fontes

