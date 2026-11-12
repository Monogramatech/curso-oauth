# Aula 4.1, Parte 2: O ataque que o PKCE resolve

**No vídeo:** PKCE: o ataque do code copiado, com e sem a defesa

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Sem PKCE, o code basta: no laboratório, um programa que só tinha o code copiado do endereço recebeu os tokens da pessoa.

Nesta parte você vê:
- por onde o code vaza, no navegador e no celular;
- o roubo num client público sem PKCE;
- por que o segredo do client não resolve: a injeção de code;
- a ideia do PKCE: o code preso a quem começou o pedido;
- o mesmo roubo e a mesma injeção, agora barrados;
- o que a RFC 9700 exige do client e do servidor.

## Reproduza

Dois clients de teste sem PKCE, o code copiado em cada caso e as mesmas trocas com o desafio.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/4.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Um app antigo, de celular, não usa PKCE. Alguém copia o code no caminho. Do que mais essa pessoa precisa para pegar os tokens?

<details><summary>Uma boa resposta</summary>

De nada secreto. Bastam o client id e o endereço de retorno, que são públicos, e trocar antes do app. O code é a única barreira.

</details>

### Exercício 2

O seu site tem back-end e guarda um client secret. Ele ainda precisa de PKCE? Por quê?

<details><summary>Uma boa resposta</summary>

Sim, a RFC 9700 recomenda. O segredo barra só a troca direta. Na injeção, o próprio site troca o code roubado, e quem barra é o PKCE.

</details>

## Fontes

- RFC 7636 (IETF, set/2015), seções 1, 4.4 e 4.6
- RFC 9700 (IETF, jan/2025), seções 2.1.1 e 4.5
- RFC 8252 (IETF, out/2017), seções 7.1 e 8.1
- Keycloak: Server Administration Guide (conferido em 11/11/2026)
- Laboratório: Keycloak 26.4 local, nov/2026
