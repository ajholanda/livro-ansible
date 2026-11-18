#!/bin/bash
#
# awx-api.sh — Dispara job templates no AWX via API REST e consulta o status.
#
# Uso:
#   export AWX_PASS='<senha-admin>'
#   export AWX_TOKEN='<token-de-acesso>'
#   bash awx-api.sh
#
# Variáveis de ambiente obrigatórias:
#   AWX_PASS   — senha do usuário admin do AWX
#   AWX_TOKEN  — token de autenticação Bearer
#
# Dependências: curl, jq
#
# Argumentos posicionais:
#   $1 — ID do job template run-webserver (padrão: 10)
#   $2 — ID do job template run-php (padrão: 11)

PASS="${AWX_PASS:?Variável AWX_PASS não definida. Execute: export AWX_PASS='<senha>'}"
TOKEN="${AWX_TOKEN:?Variável AWX_TOKEN não definida. Execute: export AWX_TOKEN='<token>'}"
# Confirme o endereço IP do host antes de executar.
HOST='http://192.168.56.8:8080'
WEB="${1:-10}"
PHP="${2:-11}"
delay='8m'

for tid in $WEB $PHP; do
	# Dispara o job e extrai o ID (testando as duas chaves mais comuns)
	RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" $HOST/api/v2/job_templates/${tid}/launch/)

	JOB_ID=$(echo $RESPONSE | jq '.job // .id')

	echo "Job ID capturado: $JOB_ID"

	if [ "$JOB_ID" != "null" ] && [ -n "$JOB_ID" ]; then
		# Consulta o status do job
		curl -s -H "Authorization: Bearer $TOKEN" $HOST/api/v2/jobs/$JOB_ID/ | jq '{id: .id, status: .status, failed: .failed}'
	else
		echo "Erro ao capturar o ID. Resposta completa do AWX:"
		echo $RESPONSE
	fi
done
