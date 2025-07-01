LOG_DIR="monitoramento_sistema"
mkdir -p $LOG_DIR

#Função para monitorar todos os logs failed, error, denied e unauthorized
function monitorando_logs() {
        grep -E "fail(ed)?|error|denied|unauthorized" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_sistema.txt
        grep -E "fail(ed)?|error|denied|unauthorized" /var/log/auth.log | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_auth.txt
}

#Função para monitorar as conexões bem-sucedidas e sem conexões.
function monitorando_rede() {
        if ping -c 5 8.8.8.8 > /dev/null; then
                echo "$(date): Conexão ativa." >> $LOG_DIR/monitoramento_rede.txt
        else
                echo "$(date): Sem conexão." >> $LOG_DIR/monitoramento_rede.txt
        fi

        if curl -s --head https://www.alura.com.br/ | grep "HTTP/2 200" > /dev/null; then
                echo "$(date): Conexão com a Alura bem-sucedida." >> $LOG_DIR/monitoramento_rede.txt
        else
                echo "$(date): Falha ao conectar com a Alura." >> $LOG_DIR/monitoramento_rede.txt
        fi
}

function executar_monitoramento() {
        monitorando_logs
        monitorando_rede
}

executar_monitoramento