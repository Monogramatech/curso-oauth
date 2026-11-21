# Aula 12.1, Parte 1: Entrar com Google num app web: o ID token e três erros

**No vídeo:** Entrar com Google num app web: o ID token e três erros

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Entrar com Google num app web com back-end, de ponta a ponta: o desenho, o token de cada salto e três erros que abrem a conta errada.

Nesta aula você vê:
- o registro, a descoberta e as chaves do Google;
- a troca pelo canal de trás e a conferência do ID token;
- o ID token de outro app aceito sem o aud;
- o e-mail como chave da conta;
- o domínio da empresa: o do pedido × o do token.

Sem conta no Google: os tokens vêm de um emissor do curso. Dois exercícios com pausa.

## Reproduza

A descoberta e as chaves do Google real, e uma loja mínima em Node para ver o aud e o domínio.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Decida se a loja deve pedir o refresh token, só para garantir.

<details><summary>Uma boa resposta</summary>

Não. O refresh token dá acesso às APIs do Google sem a pessoa presente, e a loja não usa API nenhuma.

</details>

### Exercício 2

Um painel só para a equipe da loja. O que o back-end confere no ID token?

<details><summary>Uma boa resposta</summary>

O back-end confere a assinatura, o iss, o aud, o prazo e o nonce. E confere o domínio da empresa no próprio token.

</details>

## Fontes

