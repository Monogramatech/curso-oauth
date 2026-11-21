# Aula 9.1, Parte 1: Token passthrough e client credentials: o que cada um apaga na cadeia

**No vídeo:** Token passthrough e client credentials: o problema da cadeia

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Token passthrough e client credentials numa cadeia de serviços: no laboratório, o serviço de pagamentos cobrou 99 reais da Carla, com um token válido e só um nome num cabeçalho. Nenhuma pessoa pediu essa cobrança.

Um portal, um serviço de pedidos e um de pagamentos, rodando de verdade contra o Keycloak:
- o repasse do token (token passthrough): a cobrança passa, e a auditoria do último serviço não distingue o pedido que passou pelo serviço do meio do que veio direto do portal;
- o token do próprio serviço (client credentials): o serviço do meio aparece, e a pessoa vira um nome num cabeçalho, sem assinatura; com outro nome no pedido, é o confused deputy da Aula 8.1;
- o requisito da última chamada: quem iniciou e quem age agora, assinados pelo servidor de autorização, com audiência e poder só daquele salto;
- a ponte para a troca de token da RFC 8693: delegação, a claim act e os atores anteriores.

## Reproduza

Veja o token de um serviço por dentro e o que um serviço de pagamentos mínimo anota quando a pessoa chega só num cabeçalho.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O portal entrega o token da pessoa a um agente de compras. O agente chama pedidos com client credentials e o nome da pessoa num cabeçalho.

<details><summary>Uma boa resposta</summary>

Pedidos repassa a pagamentos o token do agente, que vale nos dois serviços, e o cabeçalho. Onde some a pessoa? E onde some um serviço? Pausa e responde.

</details>

### Exercício 2

Para não perder a pessoa, pedidos manda a pagamentos dois tokens, o dele e o da pessoa, feito só para pedidos. Resolve?

<details><summary>Uma boa resposta</summary>

Melhora, porque há prova de que a pessoa entrou. Mas pagamentos teria de aceitar um token de outra audiência, que a RFC 9700 obriga a recusar.

</details>

## Fontes

