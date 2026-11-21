# Aula 7.1, Parte 2: Escopo, papel e claim: do token à decisão de acesso

**No vídeo:** Escopo, role e claim na API: RBAC, ABAC e grupos no token

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Escopo, perfil (role) e claim: o token passou no porteiro, e a API devolveu a foto de outra pessoa.

Nesta parte você vê:
- escopo × perfil: os quatro casos;
- o dono do recurso e o mesmo 404 (OWASP API1);
- RBAC × ABAC;
- a decisão fora do código (AuthZEN);
- grupos no token: o 431 e o Entra ID.

## Reproduza

Um client de serviço, a API de uma linha com a regra do dono, e a matriz escopo × perfil.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/7.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Cada loja só vê os próprios pedidos. Com o escopo pedidos ler, a atendente de Recife abre um pedido de Manaus. Quem barra, e onde?

<details><summary>Uma boa resposta</summary>

A API de pedidos. Ela compara a loja da atendente, de uma claim ou do cadastro, com a loja do pedido, que só ela conhece.

</details>

### Exercício 2

A API abre o painel de administração pelos grupos do token. No Entra ID, a diretora está em 201 grupos. O que acontece?

<details><summary>Uma boa resposta</summary>

O token chega sem a lista. A API que só lê o token nega a diretora. Melhor: um perfil de administrador no app, atribuído ao grupo.

</details>

## Fontes

