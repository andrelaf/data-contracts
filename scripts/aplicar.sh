#!/usr/bin/env sh
# Escreve no repositorio o que a verificacao propoe.
#
#   ./scripts/verificar.sh    # so olha, nao escreve
#   ./scripts/aplicar.sh      # escreve: contrato classificado + laudo + anexos
#
# Produz quatro arquivos:
#
#   contracts/<...>/contract.odcs.yaml           com `classification` por campo
#   contracts/<...>/laudos/<v>-<sha>-<crit>.md   o laudo, para quem revisa
#   ...proposta.json                             a decisao, para consulta
#   ...lint.json                                 a prova de validade ODCS
#
# Commite os quatro juntos. O pipeline **nao** escreve nada — ele so propoe e
# confere que o que esta no repositorio e o que ele proporia. Um laudo que so
# existiu no comentario de um pull request nao serve a auditoria nenhuma.
#
# Rodar duas vezes nao produz nada na segunda: os documentos sao
# deterministicos, e o mesmo contrato com o mesmo criterio da os mesmos bytes.
set -eu

RAIZ="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$RAIZ"

[ -x "$RAIZ/.harness/harness.sh" ] || {
    echo "pacote de validacao ausente — rode ./scripts/preparar.sh" >&2
    exit 2
}

"$RAIZ/.harness/scripts/imagem.sh"
exec "$RAIZ/.harness/harness.sh" aplicar "$@"
