# Aula 10.1, Parte 2: Federação de workloads: tokens de um provedor aceitos por outro

**No vídeo:** Workload identity federation: o job sem segredo guardado

Vídeo na playlist "OAuth: do login aos agentes", no canal MonogramaTech no YouTube.

## O que esta parte mostra

Workload identity federation na prática: um job pediu token ao Keycloak sem segredo guardado, só com o JWT que a plataforma assinou para ele. Outro job, com a mesma chave, foi recusado.

Nesta parte você vê:
- o segredo guardado e a ideia da federação;
- o provedor de identidade e o client federated-jwt no Keycloak 26.4 (prévia);
- o pedido sem segredo e sem client_id;
- o sub exato, o log e as conferências do Keycloak;
- as três perguntas e as três portas: Microsoft, Google e AWS.

## Reproduza

Um Keycloak 26.4 descartável com a autenticação federada em prévia, e um job que se autentica com o JWT da plataforma, sem segredo.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/10.1-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

Agora, o gancho, como exercício. O job do ambiente de teste mandou um JWT da mesma plataforma, com a assinatura e a audiência certas.

<details><summary>Uma boa resposta</summary>

Voltou 401, serviço inválido, sem mais detalhe. Será que você sabe por quê? Pausa e responde.

</details>

### Exercício 2

Um servidor confere o emissor e a audiência, mas esquece o sub. Será que o job de teste consegue o token de produção?

<details><summary>Uma boa resposta</summary>

O job de teste consegue. O JWT dele tem o mesmo emissor, a mesma audiência e uma assinatura válida; só o sub muda.

</details>

## Fontes

