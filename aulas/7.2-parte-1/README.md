# Aula 7.2, Parte 1: Validar na borda, validar em cada serviço, ou os dois

**No vídeo:** API gateway e microsserviços: onde validar o token?

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

API gateway e microsserviços: o gateway conferia todo token, e um pedido direto ao serviço de pagamentos cobrou de outra pessoa.

Nesta parte você vê:
- o gateway como primeira validação, e a porta dos fundos;
- cada serviço conferindo o próprio aud;
- o repasse do token (token passthrough) como problema;
- o token interno que o gateway emite a partir da introspecção;
- a revogação com e sem cache.

## Reproduza

Um client de serviço e dois serviços de uma linha, cada um conferindo o próprio aud.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/7.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O gateway valida o token e repassa o mesmo token para cinco serviços. Qual é o risco?

<details><summary>Uma boa resposta</summary>

Para valer nos cinco, o token tem as cinco audiências, ou ninguém confere o aud. Se vazar num deles, quem o pegar entra nos cinco.

</details>

### Exercício 2

Vazou um token interno, feito para o serviço de fotos. O que quem o pegar consegue fazer, e por quanto tempo?

<details><summary>Uma boa resposta</summary>

Entra só no serviço de fotos, como se fosse a pessoa, até o token vencer. Ele vive 1 minuto, e o serviço de pagamentos recusa pelo aud.

</details>

## Fontes

