# Aula 8.1, Parte 2: Mix-up, token em log e confused deputy

**No vídeo:** Mix-up, token em log e confused deputy no OAuth

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Mix-up, token em log e confused deputy, num laboratório de verdade: a pessoa clicou em "entrar com a Outra rede", o app respondeu "não deu, tente de novo", e o servidor do atacante já tinha os tokens da conta dela na Rede social.

Nesta parte você vê:
- o mix-up: o app que entra com dois servidores troca o code no servidor errado e entrega junto o verifier do PKCE;
- a defesa: o iss na resposta de autorização (RFC 9207), comparado ao emissor de cada pedido;
- o que, de um log de acesso, serve a quem o lê: o code quase não serve, e o access token no endereço serve até vencer;
- o access token no cabeçalho (RFC 9700), e por que a API que recusa o token no endereço não salva o que já vazou;
- o confused deputy, do artigo de 1988: o serviço que usa o próprio poder no pedido de quem não tinha;
- a defesa: decidir com o poder de quem pediu, e a ponte para a troca de token do Módulo 9.

## Reproduza

O iss na resposta de autorização do Keycloak: o anúncio nos metadados e o emissor que volta ao app.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/8.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Na tela, o Keycloak manda o code a um endereço do álbum, e o álbum leva o navegador ao atacante. Qual dos seis ataques é esse?

<details><summary>Uma boa resposta</summary>

O roubo do code, da Parte 1. O code vai no fragmento, e o navegador o leva ao atacante. A defesa: endereço exato e nenhum redirecionador aberto.

</details>

### Exercício 2

Alguém da loja 7 pede o relatório da loja 42. O serviço consulta com a própria conta, que lê todas as lojas. Qual é o ataque?

<details><summary>Uma boa resposta</summary>

O confused deputy, como no portal da Aula 4.2. O serviço precisa conferir a loja de quem pediu, ou consultar com o poder dessa pessoa.

</details>

## Fontes

