#!/bin/bash

PASS='3q8ZFykpX6O3QMCWgbUHwmcDyI0dY75R'
HOST='http://192.168.56.8:8080'
TOKEN='JHW7IcHMfkz0t2YDMXtwZ0JwwfRgdp'
WEB=10
PHP=11
delay='8m'

#curl -s -X POST \
#  -u "admin:${PASS}" \
#  -H "Content-Type: application/json" \
#  ${URL}/api/v2/job_templates/${WEB}/launch/ \
#  -d '{}'

lim=$(( 15 + RANDOM % 7 ))
echo "Number of runs: $lim"

for ((i=0; i<$lim; i++)); do
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
	echo "Waiting $delay for the next run."
	sleep $delay
done	
