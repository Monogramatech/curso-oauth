# Aula 3.2, Parte 2: Conferir as claims em ordem

**No vídeo:** Validar um JWT em ordem: o que a API confere

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Validar JWT em ordem: um token chegou com alg none, sem assinatura, e parou no primeiro portão.

Nesta parte você vê:
- nada do corpo vale antes da assinatura;
- os ataques com o alg e a lista fixa;
- os sete portões em ordem;
- por que o aud separa duas APIs;
- a folga de relógio.

## Reproduza

O validador diante de cada token.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/3.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

A função de validação da tela confere o algoritmo, a chave, a assinatura, o typ, o iss e o exp. Qual é o erro?

<details><summary>Uma boa resposta</summary>

Falta o aud. Um token feito para outra API do mesmo Keycloak passa em tudo, como o do laboratório, que só parou no aud.

</details>

### Exercício 2

O relógio de quem emite está quinze segundos adiantado, e o nbf chega quinze segundos no futuro. Com folga de trinta segundos, a API aceita?

<details><summary>Uma boa resposta</summary>

Aceita. A folga vale para os dois lados: soma no exp e desconta no nbf. Quinze segundos cabem nos trinta.

</details>

## Fontes

- RFC 8725 (fev/2020), seções 2.1, 3.1, 3.9 e 3.10
- RFC 7518 (mai/2015), seção 3.6
- RFC 9068 (out/2021), seção 4
- RFC 7519 (mai/2015), seções 4.1.4 e 4.1.5
- RFC 6750 (out/2012), seção 3.1
