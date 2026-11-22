# Aula 12.5, Parte 1: Apps de terceiros com OAuth: registro, consentimento e revogação

**No vídeo:** Apps de terceiros com OAuth: registro, consentimento e revogação

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Plataforma aberta para apps de terceiros: um app entrou sem tela de consentimento, a pessoa revogou, e ele seguiu renovando o token.

Nesta aula você vê:
- o registro dinâmico (RFC 7591) com token inicial e as políticas;
- o padrão que deixa o app entrar sem consentimento;
- o consentimento incremental e o nome que o terceiro escolhe;
- a aprovação manual dos apps;
- o alcance de cada revogação: a pessoa, a plataforma, o desenvolvedor.

Keycloak 26.4 no laboratório. Dois exercícios com pausa.

## Reproduza

Uma plataforma mínima em Node, sem Docker: a política de consentimento, a revogação pela pessoa e o app desligado e religado.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.5-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um parceiro pede um token inicial que vale um ano e mil registros. Decida o que isso arrisca.

<details><summary>Uma boa resposta</summary>

Quem tiver esse token registra apps em nome do parceiro, por um ano. Ele é uma credencial.

</details>

### Exercício 2

O Etiqueta vazou dados, e a plataforma quer cortar todo mundo agora. Decida o que fazer, sabendo que a API confere o token sozinha.

<details><summary>Uma boa resposta</summary>

Desligue o app na hora, para barrar a renovação. Fechada a investigação, exclua o app, porque desligar só suspende.

</details>

## Fontes

