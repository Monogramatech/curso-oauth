# Aula 7.3, Parte 2: PAR e RAR: pedidos de autorização seguros e detalhados

**No vídeo:** PAR e RAR: o pedido de autorização que ninguém edita

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

PAR e RAR: o app pediu autorização para imprimir três fotos por R$ 24,90. A pessoa editou a barra de endereço para R$ 2,49, e o servidor de autorização escrito para o curso emitiu o token com esse valor.

Nesta parte você vê:
- o pedido de autorização no endereço, lido e editado no navegador;
- o PAR (RFC 9126) no Keycloak: o pedido num POST autenticado e só uma referência no endereço;
- a referência de uso único, presa ao client e com prazo, e as recusas antes de qualquer tela;
- o limite do escopo: com "impressao", a API aceitou qualquer pedido;
- o RAR (RFC 9396): os detalhes em JSON, a tela, o token e a API comparando cada pedido;
- os dois juntos, e o que o FAPI 2.0 exige.

## Reproduza

Um client confidencial com o PAR exigido no Keycloak: o pedido empurrado por curl, o pedido clássico recusado e o segredo errado.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/7.3-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um request URI vazou no histórico do navegador. Um atacante consegue usá-lo para entrar no lugar da pessoa?

<details><summary>Uma boa resposta</summary>

Não. A referência não faz login: o atacante entraria com a conta dele. E ela é de uso único e vence em 60 segundos.

</details>

### Exercício 2

O servidor não publica tipos de detalhe, e a resposta do token volta sem o campo authorization details. O que o app deve concluir?

<details><summary>Uma boa resposta</summary>

O servidor ignorou os detalhes, e o token não limita fotos nem valor. O app lê a resposta, como fez com o escopo na Aula 2.2.

</details>

## Fontes

