# Aula 8.2, Parte 1: O checklist de segurança do OAuth em 2026

**No vídeo:** O checklist de segurança do OAuth: a RFC 9700 em uma lista

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

O checklist de segurança do OAuth em 2026: um auditor escrito para o curso leu, no Keycloak, a configuração de um app antigo e o reprovou em sete itens da RFC 9700. Um deles: o app recebe a senha da pessoa, e o Keycloak devolveu os tokens.

Cada item com a prova ao vivo, o que o auditor não vê (está no código do app) e o que o OAuth 2.1, ainda rascunho, muda.

A lista para a revisão de código (seção da RFC 9700, nível e a aula do curso):
- endereço de volta exato (2.1, obrigatório) · Aulas 2.2 e 8.1
- sem redirecionador aberto, no app e no servidor (2.1, proibido) · Aula 8.1
- CSRF: state ligado ao navegador, ou PKCE exigido (2.1, obrigatório) · Aulas 2.2 e 8.1
- mix-up: defesa com mais de um servidor, de preferência o iss (2.1, obrigatório) · Aula 8.1
- PKCE para client público (2.1.1, obrigatório; para confidencial, recomendado), com S256 (recomendado) · Aulas 2.2 e 4.1
- desafio do PKCE ou nonce únicos por transação (2.1.1, obrigatório; item de código) · Aula 4.1
- o servidor suporta e aplica o PKCE e barra o downgrade (2.1.1, obrigatório)
- sem Implicit (2.1.2, não deve) · Aula 4.3
- access token preso ao client (2.2.1, recomendado) · Aula 7.3
- refresh token de client público preso ou com rotação (2.2.2, obrigatório) · Aulas 3.3 e 7.3
- audiência e privilégio restritos (2.3, recomendado); a API recusa token de outra audiência (obrigatório) · Aulas 3.3 e 7.2
- sem Password (2.4, proibido) · Aula 4.3
- o servidor exige a autenticação do client (2.5, recomendado), de preferência com chave · Aulas 4.2 e 7.3
- metadados publicados (2.6, recomendado) · Aula 2.1
- TLS de ponta a ponta (2.6, recomendado); endereço de volta em HTTP só no loopback de app nativo (proibido fora dele)
- sem token no endereço da chamada à API (4.3.2, proibido) · Aula 8.1
- clickjacking barrado (4.16, obrigatório)

## Reproduza

Revise um client no Keycloak: os campos que a lista confere, o Password aberto e fechado, e o PKCE exigido.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/8.2-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Na tela, a configuração do terceiro app, um client público. Aponte três problemas, com o item e o nível de cada um.

<details><summary>Uma boa resposta</summary>

O asterisco no endereço e o PKCE que o registro não exige. As duas regras são obrigatórias. E o Implicit ligado, que a RFC desaconselha.

</details>

### Exercício 2

Um site com back-end e segredo não usa PKCE. Pela RFC 9700, ele quebra uma regra obrigatória? E pelo rascunho do OAuth 2.1?

<details><summary>Uma boa resposta</summary>

Pela RFC 9700, não; para o confidencial, ela recomenda o PKCE. O segredo barra quem copia o code, mas não a injeção, da Aula 4.1.

</details>

## Fontes

