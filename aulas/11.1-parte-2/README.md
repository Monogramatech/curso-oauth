# Aula 11.1, Parte 2: Autorização no MCP

**No vídeo:** Autorização no MCP: como o servidor de ferramentas usa OAuth

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Autorização no MCP: o servidor de ferramentas responde 401 e aponta os metadados, e o cliente chega sozinho a um token feito só para aquele servidor.

Nesta parte você vê:
- o servidor MCP como resource server (especificação 2026-07-28);
- o 401, os metadados do servidor (RFC 9728) e os do Keycloak;
- o documento de metadados do cliente no lugar do registro dinâmico;
- o resource (RFC 8707) e o iss (RFC 9207) no login;
- o aud conferido, sem repassar o token;
- o 403 de escopo e a união dos escopos.

## Reproduza

Um servidor MCP mínimo em Node, sem Docker: o 401, o aud conferido e o 403 de escopo.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/11.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O servidor MCP trocou de servidor de autorização, e o cliente tem um identificador cadastrado no antigo. O que ele faz?

<details><summary>Uma boa resposta</summary>

O cliente não reaproveita o identificador. A especificação manda guardar cada identificador junto do emissor e, com emissor novo nos metadados, registrar de novo.

</details>

### Exercício 2

O cliente pediu de novo só o escopo do desafio, o de escrita. O que acontece com a consulta?

<details><summary>Uma boa resposta</summary>

O cancelamento passa, mas a consulta perde a leitura, porque aqui escrever não inclui ler. No laboratório, ela levou 403, pedindo a leitura.

</details>

## Fontes

