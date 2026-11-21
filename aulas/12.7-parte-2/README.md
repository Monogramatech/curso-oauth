# Aula 12.7, Parte 2: Agente de IA com delegação no Keycloak: may_act e act

**No vídeo:** Agente de IA com delegação no Keycloak: may_act e act

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

Agente de IA com delegação no Keycloak: a ponte sem tela não delega, e o agente entra pelo consentimento da pessoa.

Nesta parte você vê:
- a delegação do Keycloak 26.8 (prévia), num login federado pelo Entra;
- may_act no token da pessoa e act no token do agente, que só lê;
- o atalho do token da pessoa, e o registro que o fecha;
- a permissão retirada e o que ela não alcança;
- os rastros da troca.

## Reproduza

Um servidor mínimo em Node, sem Docker: may_act, act, os atalhos e o corte.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/12.7-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O agente roda à noite, sem a Bia na frente. O que acontece com a delegação?

<details><summary>Uma boa resposta</summary>

O token do agente vence junto com o da Bia, e não renova. Para a próxima troca, ele precisa de outro token dela.

</details>

### Exercício 2

O estoque quer deixar o agente ajustar até dez caixas sozinho, e acima disso só com a Bia confirmando. Como você monta isso?

<details><summary>Uma boa resposta</summary>

O ajuste entra no registro do agente. O estoque confere a claim do ator, o limite, e se a própria Bia pode ajustar.

</details>

## Fontes

