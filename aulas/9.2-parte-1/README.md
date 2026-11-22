# Aula 9.2, Parte 1: Os parâmetros: subject_token, actor_token, audience, scope

**No vídeo:** Token exchange (RFC 8693) na prática: subject token e audience

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Token exchange (RFC 8693) na prática: no laboratório, o serviço de pedidos mandou ao Keycloak o token que recebeu da pessoa e levou de volta um token novo, só para pagamentos. Um texto qualquer no actor token passou: o Keycloak 26.4 respondeu 200 e nem olhou.

A troca de token, parâmetro por parâmetro:
- o pedido, a resposta e o token novo (a mesma pessoa, o azp de quem trocou, só a audiência do destino);
- quem pode trocar: autenticado, confidencial, com a troca ligada e na audiência do token;
- a audiência e o escopo saem do registro de quem troca: um escopo que o token da pessoa não tinha entrou;
- o tipo pedido, o resource ignorado e o relógio da versão 26.4;
- o actor token ignorado e o segundo salto, em que o azp guarda só o último que pediu o token.

## Reproduza

Faça uma troca de token no Keycloak: o token novo, o pedido sem o tipo do token e o actor token ignorado. Sem navegador, o token de serviço de quem troca faz o papel do token recebido.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/9.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Pagamentos precisa chamar notas fiscais, com o poder de emitir nota, em nome da pessoa. Monte o pedido e diga o que o Keycloak exige.

<details><summary>Uma boa resposta</summary>

Pagamentos se autentica e diz que é uma troca. Manda o token que recebeu no subject token, com o tipo access token.

</details>

### Exercício 2

O serviço de notas fiscais quer anotar o nome da pessoa, como a auditoria de pagamentos. O token do segundo salto traz o nome?

<details><summary>Uma boa resposta</summary>

Não traz. Veio o sub da pessoa, mas sem o nome, porque o registro de pagamentos não tem o escopo de perfil.

</details>

## Fontes

