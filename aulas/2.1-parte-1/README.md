# Aula 2.1, Parte 1: Resource owner, client, authorization server, resource server

**No vídeo:** Os 4 papéis do OAuth: por que o resource owner não é o dono

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No portal da empresa, o funcionário altera dados que não são dele, e mesmo assim o OAuth o chama de resource owner, o "dono do recurso". Veja os quatro papéis do OAuth pelo que cada um faz, encontre cada um num access token real e entenda por que "dono" engana.

Nesta parte você vê:
- resource owner, client, authorization server e resource server, pela RFC 6749;
- por que client não é o navegador (e o caso da SPA);
- os papéis dentro do token: iss, azp, sub, scope, e a aud que faltou;
- papel, não posse: o portal corporativo com Entra ID;
- os limites da empresa: admin consent, RBAC e a interseção escopo × perfil;
- o caso sem pessoa (Client Credentials) e o papel que vale por conversa.

## Reproduza

Os comandos mostram os papéis dentro do seu próprio token. Os valores vão sair diferentes dos da tela: são gerados a cada execução.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/2.1-parte-1/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

No app de fotos e no portal da empresa, quem é o resource owner? E quem limita o que o app faz em nome dele?

<details><summary>Uma boa resposta</summary>

Nos dois casos, a pessoa em nome de quem o app age. Nas fotos, você limita o app. No portal, a empresa limita app e pessoa.

</details>

### Exercício 2

Um serviço de relatórios chama a API de vendas toda madrugada, sem ninguém logado. Quem é o resource owner?

<details><summary>Uma boa resposta</summary>

Não há pessoa. O serviço de relatórios age em nome próprio, no lugar do resource owner, com o acesso que o administrador liberou.

</details>

## Fontes

- RFC 6749, The OAuth 2.0 Authorization Framework (IETF, out/2012), seções 1.1 e 1.3.4
- RFC 9700, Best Current Practice for OAuth 2.0 Security (IETF, jan/2025), seção 2.3
- OpenID Connect Core 1.0 (errata 2, dez/2023), seção 2 (azp)
- Microsoft Learn: permissions and consent overview; user and admin consent overview; access token claims reference (consultados em nov/2026)
- Laboratório: Keycloak 26.4 local e Node 18, nov/2026
