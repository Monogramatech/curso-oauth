# Aula 12.4, Parte 1: Client credentials em produção: um client por sistema e a chave vazada

**No vídeo:** Client credentials em produção: um client por sistema e a chave vazada

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Client credentials numa integração de verdade: a chave do job vazou, saiu da lista, e o Keycloak ainda aceitou a cópia.

Nesta aula você vê:
- um client por sistema, com escopo e audiência próprios;
- o token sem pessoa, sem sessão e sem refresh token;
- o token guardado no job pelo prazo da resposta;
- a chave do job num JWKS por endereço e a troca de chave;
- a chave que vazou: o cache pelo kid e a ordem que corta.

Keycloak 26.4 no laboratório. Dois exercícios com pausa.

## Reproduza

Emissor mínimo em Node, sem Docker: o cache de chaves pelo kid, a janela de 10 s e a chave que vazou.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.4-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A equipe do faturamento quer usar o client do job de estoque, que já funciona. Decida o que se perde.

<details><summary>Uma boa resposta</summary>

O que se perde é a separação. O mesmo registro passa a ter os dois escopos. E um vazamento no faturamento abre o estoque.

</details>

### Exercício 2

A chave do job vazou numa sexta à noite. Decida a ordem dos passos para cortar a cópia sem parar o lote.

<details><summary>Uma boa resposta</summary>

Gere a chave nova, publique só ela e passe a assinar com ela. A busca do Keycloak já tira a velha.

</details>

## Fontes

