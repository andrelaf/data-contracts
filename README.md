# data-contracts

Contratos de dados no padrão **ODCS**, verificados e classificados quanto a
privacidade em cada pull request.

Este repositório guarda **o dado descrito** — e nada mais. A ferramenta que
valida e o vocabulário que classifica vêm de fora, fixados por versão e sha256
em [`harness.lock`](harness.lock).

---

## Por que a ferramenta não mora aqui

Porque quem escreve o contrato não pode escrever o critério que o julga.

O gate de privacidade só significa alguma coisa se o autor de um contrato não
puder, no mesmo pull request, adicionar ao glossário o termo que fecha a própria
lacuna, ou rebaixar no catálogo a classificação do próprio campo. Deixar
glossário e catálogo em outro artefato transforma isso em impossibilidade — não
em política de revisão bem preenchida.

Consequência que vale saber: **subir a versão em `harness.lock` pode mudar a
classificação de um campo sem que nenhum contrato mude.** Por isso é um pull
request, revisado, com dono próprio no `CODEOWNERS`.

## Estrutura

```
contracts/<dominio>/<contrato>/
    contract.odcs.yaml          o contrato — a única coisa que você edita
    laudos/<versao>-<sha>.md    o laudo de classificação, emitido e nunca sobrescrito
harness.lock                    qual ferramenta e qual vocabulário julgam este repo
```

O nível de domínio não é decoração: é ele que permite ao `CODEOWNERS` rotear a
revisão para quem responde por aquele dado.

## Verificar antes de abrir o PR

```bash
./scripts/preparar.sh      # baixa o pacote fixado (idempotente)
./scripts/verificar.sh     # o mesmo veredito que o pull request vai dar
```

Requisitos: Docker e `gh` autenticado. **Não** requer Rust — o binário vem
pronto no pacote.

O exit code é o veredito:

| | |
|---|---|
| `0` | passou |
| `1` | reprovou — o motivo sai ancorado no arquivo |
| `5` | bloqueado, aguardando decisão humana — não é erro seu |

Nada é escrito no contrato. O contrato enriquecido e o laudo saem **propostos**
em `evidence/`, e entram no repositório quando você aceitar a proposta.

## O ciclo

```bash
git checkout -b feat/202608/cadastro-clientes
# edite contracts/clientes/cadastro/contract.odcs.yaml
./scripts/verificar.sh
git push -u origin feat/202608/cadastro-clientes
gh pr create --base main --fill
```

O pull request dispara a verificação, comenta o laudo proposto e, pelo
`CODEOWNERS`, chama para revisão quem responde pelo domínio. Quando o veredito é
`5`, o job **não fica vermelho** — nada está errado no contrato, falta decisão
humana. Quem segura o merge é a revisão aprovada.

## O que fica no repositório, e o que não fica

| Fica | Não fica |
|---|---|
| `contracts/` e os laudos emitidos | glossário e catálogo de classificação |
| `harness.lock` — a versão do critério | o binário do validador |
| a configuração do pipeline | `evidence/` e `trace/` — são artefato do job |
