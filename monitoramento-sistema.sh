#!/bin/bash


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

#Função para monitorar o uso de disco.
function monitorando_disco() {
        echo "$(date)" >> $LOG_DIR/monitoramento_disco.txt
        df -h | grep -v "snapfuse" | awk '$5+0 > 1 {print $1 " esta com " $5 " de uso."}' >> $LOG_DIR/monitoramento_disco.txt
        echo "Uso de disco no diretorio principal:" >> $LOG_DIR/monitoramento_disco.txt
        du -sh /home/vinic >> $LOG_DIR/monitoramento_disco.txt
}

#Função para monitorar o uso de memória ram
function monitorando_hardware() {
        echo "$(date)" >> $LOG_DIR/monitoramento_hardware.txt
        free -h | grep Mem | awk '{print "Memória RAM Total:" $2 ", Usado:" $3 ", Livre:" $4}' >> $LOG_DIR/monitoramento_hardware.txt
        #Monitorando o uso da CPU
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "Uso da CPU: " 100 - $1 " "%"}' >> $LOG_DIR/monitoramento_hardware.txt
        echo "Operações de leitura e escrita:" >> $LOG_DIR/monitoramento_hardware.txt
        iostat | grep -E "Device|^sda|^sdb|^sdc" | awk '{print $1, $2, $3, $4}' >> $LOG_DIR/monitoramento_hardware.txt
}

function executar_monitoramento() {
        monitorando_logs
        monitorando_rede
        monitorando_disco
        monitorando_hardware
}

executar_monitoramento