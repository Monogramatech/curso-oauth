# Aula 8.1, Parte 1: CSRF, redirecionamento aberto e roubo de código

**No vídeo:** CSRF, redirecionamento aberto e roubo de código no OAuth

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

CSRF, redirecionamento aberto e roubo de código, num navegador de verdade: com a sessão aberta, a pessoa clicou no link de um jogo grátis e, sem senha e sem tela de login, o site do atacante trocou o code dela pelos tokens.

Nesta parte você vê:
- o CSRF no retorno: o app sem state troca o code do atacante, e a foto da vítima vai para a conta dele;
- por que o cookie SameSite Lax não barra o retorno, e como o state ligado ao navegador e o PKCE exigido barram;
- o redirecionamento aberto no app (o "voltar para onde você estava") e no servidor de autorização (um escopo que não existe, e o redirecionamento antes de qualquer login);
- o roubo do code: o asterisco no endereço de retorno, o redirecionador do app e o fragmento que o navegador leva junto;
- por que o PKCE não salva quando o atacante monta o pedido;
- as defesas medidas: o endereço exato no registro e o redirecionador preso a uma lista (RFC 9700).

## Reproduza

A configuração do endereço de retorno no Keycloak: o endereço exato, o asterisco no fim e o erro que o servidor devolve sem mostrar tela.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/8.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O cookie da ida é Lax, e vai junto no retorno que vem do site do atacante. O CSRF funciona?

<details><summary>Uma boa resposta</summary>

Não. O cookie chega, mas aponta para o state da vítima. O endereço traz o state do atacante, e os dois não batem.

</details>

### Exercício 2

O álbum corrigiu o registro para o endereço exato, e o Keycloak já barra o roubo. Ainda falta corrigir alguma coisa?

<details><summary>Uma boa resposta</summary>

Falta. O endereço exato barra o roubo antes de qualquer code, mas o redirecionador continua aberto.

</details>

## Fontes

