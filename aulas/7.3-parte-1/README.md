# Aula 7.3, Parte 1: mTLS e DPoP: o token que não serve a quem o roubou

**No vídeo:** DPoP e mTLS: o token que não serve a quem o roubou

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

DPoP e mTLS: dois tokens vazaram num log. O de portador funcionou na mão de quem copiou; o preso a uma chave levou 401 de seis jeitos.

Nesta parte você vê:
- o token de portador vazado, funcionando;
- o DPoP: a chave do app, a prova e o token preso;
- o token DPoP vazado, recusado seis vezes, e o refresh preso;
- o mTLS: o token preso ao certificado do cliente;
- onde a proteção acaba: o app invadido.

## Reproduza

Um client de serviço com DPoP exigido e um cliente DPoP de uma linha, contra o userinfo do Keycloak.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/7.3-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Com o DPoP ligado, um token vazou num log, junto com a prova do pedido. O atacante consegue usá-lo? Por quê?

<details><summary>Uma boa resposta</summary>

Para pedidos novos, não, porque falta a chave. A prova do log só repete aquele pedido, até ficar velha, se a API não guardar o identificador.

</details>

### Exercício 2

Um script malicioso roda dentro do app que usa DPoP. O DPoP impede o ataque?

<details><summary>Uma boa resposta</summary>

Não. O script faz provas com a chave do app e, sem nonce do servidor, deixa provas para depois. O DPoP protege o token, não o app.

</details>

## Fontes

