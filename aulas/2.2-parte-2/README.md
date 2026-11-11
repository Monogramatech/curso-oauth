# Aula 2.2, Parte 2: Escopo, consentimento e o parâmetro state

**No vídeo:** Escopo, consentimento e state: quem decide cada um

Vídeo na playlist "OAuth: do login aos agentes", no canal Monograma no YouTube.

## O que esta parte mostra

No laboratório, um login sem o parâmetro state funcionou: o servidor devolveu o code do mesmo jeito. Então quem confere o state? Veja o que o app pede (o escopo), o que a pessoa concede (o consentimento) e por que só o app pode barrar o ataque de CSRF no retorno do login.

Nesta parte você vê:
- o escopo: o app pede, o servidor concede, e a resposta diz o que saiu;
- escopos padrão e o erro invalid_scope;
- a tela de consentimento: permitir, cancelar (access_denied), lembrar e revogar;
- o state e o CSRF: o atacante injeta o próprio code no app da vítima;
- a defesa: state aleatório, ligado à sessão e de uso único, junto com o PKCE.

## Reproduza

Os comandos mostram a tela de consentimento, o Cancelar, o scope concedido, o consentimento guardado, um escopo desconhecido e um login sem state. Use uma janela anônima.

Com o laboratório no ar (`bash laboratorio/preparo.sh`, uma vez):

```bash
bash aulas/2.2-parte-2/reproduza.sh
```

O script segue os mesmos comandos da descrição do vídeo, na ordem. Quando ele pedir um login, abra o endereço numa janela anônima, entre com `voce` / `teste123` e cole o `code` da barra de endereço.

## Exercícios

### Exercício 1

O app pediu fotos publicar, mas a resposta do token veio sem esse escopo. O que pode ter acontecido?

<details><summary>Uma boa resposta</summary>

O servidor não concedeu, pela política dele ou pela escolha da pessoa. O app precisa ler o scope da resposta, e não supor.

</details>

### Exercício 2

O app não confere o state na volta, e também não usa PKCE. O que um atacante consegue fazer?

<details><summary>Uma boa resposta</summary>

Ligar a vítima à conta dele. Ele faz o app trocar o code dele sem perceber. Se o servidor exigisse PKCE, essa troca falharia.

</details>

## Fontes

- RFC 6749 (IETF, out/2012), seções 3.3, 4.1.1, 4.1.2.1 e 10.12
- RFC 9700 (IETF, jan/2025), seções 2.1, 2.3, 4.2.4 e 4.7
- Laboratório: Keycloak 26.4 local, nov/2026
