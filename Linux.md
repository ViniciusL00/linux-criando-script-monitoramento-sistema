# 📊 Linux: Criando Script de Monitoramento de Sistema

## 📝 Módulo 1 – Manipulando e Analisando Logs do Sistema

---

### 📁 Arquivos de Logs do Sistema

#### 🔍 `/var/log/syslog`
- Contém logs gerais do sistema: mensagens do kernel, serviços, atividades de usuários e hardware.
- **Comando para visualizar paginado:**  
  ```bash
  less /var/log/syslog
  ```
- **Visualização em tempo real:**  
  ```bash
  tail -f /var/log/syslog
  ```

#### 🔐 `/var/log/auth.log`
- Armazena logs de autenticação e autorização (logins, sudo, SSH).
- **Requer permissão de superusuário:**  
  ```bash
  sudo less /var/log/auth.log
  ```

---

### 📚 Outros Logs Relevantes
- `/var/log/kern.log`: Mensagens do kernel.
- `/var/log/dmesg`: Inicialização do kernel.
- `/var/log/boot.log`: Detalhes do boot.
- `/var/log/faillog`: Tentativas de login falhas.
- `/var/log/lastlog`: Últimos logins.
- `/var/log/apt/`: Logs de instalação de pacotes.
- `/var/log/cron`: Execuções do cron.
- `/var/log/mail.log`: Atividades de e-mail.
- `/var/log/messages`: Log geral alternativo.
- `/var/log/wtmp`, `btmp`, `utmp`: Sessões e logins de usuários.

---

### 🔎 Filtrando Logs com Regex e Grep

**Comando:**
```bash
grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog
```

- `-E`: Ativa expressões regulares estendidas.
- Busca por palavras associadas a erros e falhas de segurança.

---

### 🧠 Entendendo Regex (Expressões Regulares)

- **Literais:** `abc` encontra exatamente "abc".
- **Metacaracteres comuns:**
  - `.`: Qualquer caractere
  - `^`: Início da linha
  - `$`: Final da linha
  - `[]`: Conjunto
  - `*`, `+`, `?`, `{n,m}`, `|`: Repetições e alternativas
- **Classes especiais:**
  - `\d`: Dígito
  - `\w`: Alfanumérico
  - `\s`: Espaço
- Ferramentas úteis: Regex101, RegExr, RegexPal

---

### 📑 Formatando Logs com Awk

**Comando:**
```bash
grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}'
```

- Exibe: data, serviço, horário, tipo de log
- Usado para tornar logs mais legíveis e informativos

**Redirecionando para arquivo:**
```bash
> monitoramento_logs_sistema.txt
```

---

### 🛠️ Criando Script de Monitoramento

```bash
#!/bin/bash

LOG_DIR="monitoramento-sistema"
mkdir -p $LOG_DIR
grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_sistema.txt
```

**Comandos:**
- Criar script: `vim monitoramento-sistema.sh`
- Dar permissão: `sudo chmod +x monitoramento-sistema.sh`
- Executar script: `./monitoramento-sistema.sh`

---

### ✅ Resultado Esperado

- Pasta `monitoramento-sistema` criada
- Arquivo `monitoramento_logs_sistema.txt` com logs filtrados por data, hora, serviço e tipo de erro

---

### 🧩 Conclusão

Neste módulo, aprendemos:
- A importância e os tipos de logs no Linux
- Como filtrar logs críticos com `grep` e expressões regulares
- Como formatar logs com `awk` para análise
- Como automatizar a coleta de dados com scripts em Bash

Ferramentas como `grep`, `awk` e `regex` são essenciais para administradores de sistema e profissionais de DevOps que buscam eficiência no monitoramento e diagnóstico de sistemas Linux.

---

# 📡 Módulo 2: Monitorando a Rede

## 🌐 Verificando a Conectividade com a Internet

### 🔍 Por que monitorar a rede?
- Identificar falhas de conectividade
- Garantir funcionamento de serviços dependentes de internet
- Evitar interrupções inesperadas

### 📶 Comando `ping`
- Usado para verificar a conexão entre dois dispositivos de rede
- IP 8.8.8.8 é um DNS do Google, geralmente estável
- Sintaxe:
  ```bash
  ping 8.8.8.8
  ```
- Para parar: `Ctrl + C`
- Para limitar pacotes: `ping -c 5 8.8.8.8`
- Indicadores na saída:
  - `icmp_seq`: sequência do pacote
  - `ttl`: quantidade de saltos
  - `time`: latência em ms

### 📁 Redirecionando saída para o "buraco negro"
```bash
ping -c 5 8.8.8.8 > /dev/null
```
Usado para não mostrar a saída no terminal.

---

## 📜 Script de Monitoramento de Rede

```bash
if ping -c 1 8.8.8.8 > /dev/null; then
    echo "$(date): Conexão ativa." >> $LOG_DIR/monitoramento_rede.txt
else
    echo "$(date): Sem conexão." >> $LOG_DIR/monitoramento_rede.txt
fi
```

---

## 🎮 Ping no Linux x Ping nos Jogos
- Ambos medem a latência (RTT)
- Linux: diagnóstico técnico de rede
- Jogos: experiência do usuário (lag, delay)
- Objetivo é o mesmo, mas contextos diferentes

---

## 🌐 Verificando Aplicações com `curl`

### 🧪 Testando uma URL
```bash
curl https://www.alura.com.br/
```
- Retorna o HTML da página

### 🎯 Focando só no cabeçalho (status HTTP)
```bash
curl -s --head https://www.alura.com.br/ | grep "HTTP/2 200"
```
- `-s`: modo silencioso
- `--head`: apenas cabeçalhos
- `grep`: filtra o status

### ✅ Incrementando no script:
```bash
if curl -s --head https://www.alura.com.br/ | grep "HTTP/2 200" > /dev/null; then
    echo "$(date): Conexão com a Alura bem-sucedida." >> $LOG_DIR/monitoramento_rede.txt
else
    echo "$(date): Falha ao conectar com a Alura." >> $LOG_DIR/monitoramento_rede.txt
fi
```

---

## ⚙️ Principais Opções do `curl`

### 🔗 Requisições HTTP
- `-X <METHOD>`: método HTTP (GET, POST…)
- `-d`: dados para POST

### 📬 Cabeçalhos
- `-H`: adiciona headers
- `--head`: apenas cabeçalhos

### 🔐 Autenticação
- `-u`: usuário e senha
- `--oauth2-bearer`: token OAuth2

### 📥 Download de Arquivos
- `-O`: salva com nome original
- `-o`: nome personalizado

### 👀 Visualização
- `-v`: verbose
- `-s`: silent
- `-w`: output formatado

### ➰ Redirecionamentos
- `-L`: segue redirecionamentos

### 🔐 Segurança
- `-k`: ignora SSL inválido

---

## 🔁 Organizando com Funções no Script

### 💡 Por que usar funções?
- Clareza de propósito
- Reutilização
- Organização e manutenção mais fáceis

### 🧩 Exemplo de Funções

```bash
function monitorando_logs() {
    grep -E "(fail(ed)?|error|denied|unauthorized)" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_sistema.txt
}

function monitorando_rede() {
    if ping -c 1 8.8.8.8 > /dev/null; then
        echo "$(date): Conectividade ativa." >> $LOG_DIR/monitoramento_rede.txt
    else
        echo "$(date): Sem conexão." >> $LOG_DIR/monitoramento_rede.txt
    fi

    if curl -s --head https://www.alura.com.br/ | grep "HTTP/2 200" > /dev/null; then
        echo "$(date): Conexão com a Alura bem-sucedida." >> $LOG_DIR/monitoramento_rede.txt
    else
        echo "$(date): Falha ao conectar com a Alura." >> $LOG_DIR/monitoramento_rede.txt
    fi
}
```

### 🧠 Função principal:
```bash
function executar_monitoramento() {
    monitorando_logs
    monitorando_rede
}

executar_monitoramento
```

---

## 📝 Comentários em Scripts Bash

### 💬 Como comentar:
```bash
# Comentário de uma linha

# Várias linhas:
# Linha 1
# Linha 2
```

### 🧠 Boas práticas:
- Explique o **porquê**, não o óbvio
- Evite excesso
- Não comente o que já é claro no nome da função/variável

---

## 📥 Parâmetros em Funções Bash

### 📦 Como passar:
```bash
minha_funcao() {
    echo "Parâmetro 1: $1"
    echo "Parâmetro 2: $2"
}
minha_funcao "um" "dois"
```

### 📊 Extras:
- `$#`: total de parâmetros
- `$@`: todos os parâmetros
- `${1:-valor}`: valor padrão caso não informado

### ✔️ Boas práticas:
- Valide parâmetros
- Comente o que cada parâmetro representa

---

🧠 **Resumo Final:**
Esse módulo focou em **monitoramento de rede e conectividade**, ensinando a usar `ping` e `curl` para validar se a máquina está conectada e se uma aplicação está acessível. Também mostrou **como organizar scripts com funções**, **usar parâmetros** e **comentar de forma eficiente** para tornar o código **modular e legível**.

---

# 📦 Módulo 3: Gerenciando Discos e Armazenamento

> Um mergulho no uso de disco, sistemas de arquivos e como monitorar tudo isso via Shell Script!

---

## 📊 Verificando o Uso de Disco

### 🔍 Comando `df`

- Exibe informações sobre o **uso de disco**.
- Colunas importantes:
  - `Filesystem`: nome do sistema de arquivos
  - `1K-blocks`: espaço total (em blocos de 1KB)
  - `Used`: espaço usado
  - `Available`: espaço disponível
  - `Use%`: porcentagem utilizada
  - `Mounted on`: ponto de montagem

### 🧠 Exemplo:
```
Filesystem     1K-blocks      Used       Available    Use%    Mounted on
/dev/sdc       1055762868     1910072    1000149324    1%         /
```

---

### 📏 Tornando legível com `-h` (human readable)
```
df -h
```
➡️ Exibe tamanhos em GB, MB etc.

### 📜 Exibindo todos os sistemas de arquivos:
```
df -a
```

### 🧱 Exibindo tipos de sistemas de arquivos:
```
df -T
```

### 📌 Inodes (metadados dos arquivos)
```
df -i
```
- Inodes são estruturas que guardam metadados dos arquivos (permissões, dono, timestamps).
- Sem inodes livres = não dá pra criar novos arquivos, mesmo com espaço.

### 📊 Informações gerais do disco:
```
df --total
```
- Mostra totais gerais no final da tabela.

### 🧪 Combinação de opções:
```
df -h --total
```

---

## 💻 Adicionando Monitoramento de Disco no Script

### ✅ Lógica de monitoramento:

```bash
df -h | grep -v "snapfuse" | awk '$5+0 > 1 {print $1 " esta com " $5 " de uso."}'
```

- Filtra sistemas com mais de 1% de uso.
- Ignora partições Snap.
- Exibe mensagem com o nome da partição e o uso.

### ✍️ Dentro da função `monitorando_disco`:

```bash
function monitorando_disco() {
    echo "$(date)" >> $LOG_DIR/monitoramento_disco.txt
    df -h | grep -v "snapfuse" | awk '$5+0 > 1 {print $1 " esta com " $5 " de uso."}' >> $LOG_DIR/monitoramento_disco.txt
    echo "Uso de disco no diretório principal:" >> $LOG_DIR/monitoramento_disco.txt
    du -sh /home/vinic >> $LOG_DIR/monitoramento_disco.txt
}
```

---

## 📁 Mergulhando em Sistemas de Arquivo

### 🗂️ O que é?
> Estrutura que organiza, armazena e gerencia dados nos dispositivos de armazenamento.

### 🔧 Componentes:

- **Diretórios e Arquivos**
- **Blocos de dados**
- **Metadados**
- **Tabela de alocação**

### 📚 Tipos comuns:

| Tipo   | Características |
|--------|------------------|
| FAT32  | Simples, arquivos até 4GB |
| NTFS   | Avançado, comum no Windows |
| EXT4   | Comum no Linux |
| APFS   | Apple, otimizado pra SSD |
| exFAT  | Portátil, para dispositivos móveis |

### 🔐 Funções principais:

- Armazenar, organizar e gerenciar espaço
- Controle de acesso com permissões

### 🛡️ Recursos úteis:

- **Journaling**
- **Permissões**
- **Compressão**
- **Criptografia**

---

## 📂 Verificando Espaço em Diretórios Específicos

### 🧪 Comando `du` (Disk Usage)

```bash
du -sh /home/vinic
```
➡️ Mostra o uso total do diretório `/home/vinic` de forma legível.

### ✅ Incorporando no script:

```bash
echo "Uso de disco no diretório principal:" >> $LOG_DIR/monitoramento_disco.txt
du -sh /home/vinic >> $LOG_DIR/monitoramento_disco.txt
```

---

## 🔧 Opções úteis do `du`

| Opção               | Descrição |
|---------------------|----------|
| `-h`                | Tamanhos legíveis (KB, MB, GB) |
| `-s`                | Mostra apenas o total |
| `-a`                | Lista arquivos e diretórios |
| `-c`                | Soma e mostra total geral |
| `--max-depth=N`     | Limita profundidade da listagem |
| `-d N`              | Alternativa ao `--max-depth` |
| `--time`            | Mostra data de modificação |
| `-x`                | Restringe ao sistema de arquivos atual |
| `--exclude=PATTERN` | Exclui arquivos/diretórios por padrão |

---

📁 **Com isso, conseguimos monitorar o uso do disco e diretórios no Linux de forma prática, clara e eficiente.**

---

# 📊 Módulo 4: Monitorando o Hardware do Sistema

## 🧠 Monitoramento de Memória RAM

A memória **RAM** é onde os programas em execução ficam armazenados temporariamente. Quando o PC é desligado, tudo nela se perde.

### ✅ Comando `free -h`
Exibe o uso da memória de forma legível:

```
free -h
```

### 📌 Saída relevante:
- **Mem:** Memória RAM
- **Total:** Quantidade total de memória
- **Used:** Quantidade usada
- **Free:** Quantidade livre
- **Shared:** Memória compartilhada
- **Buff/Cache:** Memória usada para cache e buffer
- **Available:** Quantidade realmente disponível para uso

### 📤 No script:
```bash
free -h | grep Mem | awk '{print "Memoria RAM Total: " $2 ", Usada: " $3 ", Livre: " $4}'
```

---

## 🧮 Tipos de Memória no Computador

| Tipo            | Velocidade     | Custo por GB   | Capacidade   | Volátil? |
|-----------------|----------------|----------------|--------------|----------|
| Cache           | ⚡⚡⚡ Altíssima | 💸💸💸 Muito alto| KB - MB      | Sim      |
| RAM             | ⚡ Muito alta   | 💸 Alto         | GB           | Sim      |
| SSD (NVMe)      | 🚀 Alta        | 💸 Alto         | GB - TB      | Não      |
| SSD (SATA)      | 🚀 Moderada    | 💸 Moderado     | GB - TB      | Não      |
| HDD             | 🐢 Lenta       | 💰 Baixo        | GB - TB      | Não      |
| Pendrive / Flash| 🐌 Variável     | 💰 Moderado     | GB - TB      | Não      |
| Memória Virtual | 🐢 Depende do disco | 🆓 Sem custo | Depende do disco | Não  |

---

## 🧮 Unidade GiB vs GB

| Unidade | Tamanho em bytes     | Base |
|---------|----------------------|------|
| **1 GiB** | 1.073.741.824 bytes | Binária (2³⁰) |
| **1 GB**  | 1.000.000.000 bytes | Decimal (10⁹) |

---

## ⚙️ Monitoramento de CPU

### ✅ Comando `top -bn1`
Modo batch, execução única:

```bash
top -bn1
```

### 🔍 Extraindo uso da CPU
Pegamos o valor de ociosidade da CPU (`id`) e subtraímos de 100 para saber o uso real:

```bash
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "Uso da CPU: " 100 - $1 "%"}'
```

---

## 📁 Monitoramento de Leitura e Escrita em Disco

### ✅ Comando `iostat`
Mostra a atividade dos dispositivos de armazenamento:

```bash
iostat
```

### 🔍 Filtro para dispositivos relevantes (sda, sdb, sdc):
```bash
iostat | grep -E "Device|^sda|^sdb|^sdc" | awk '{print $1, $2, $3, $4}'
```

---

## 📝 Script Final (Trecho do monitorando_hardware)

```bash
function monitorando_hardware() { 
    echo "$(date)" >> $LOG_DIR/monitoramento_hardware.txt
    free -h | grep Mem | awk '{print "Memoria RAM Total: " $2 ", Usada: " $3 ", Livre: " $4}' >> $LOG_DIR/monitoramento_hardware.txt
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "Uso da CPU: " 100 - $1 "%"}' >> $LOG_DIR/monitoramento_hardware.txt
    echo "Operacoes de leitura e escrita:" >> $LOG_DIR/monitoramento_hardware.txt
    iostat | grep -E "Device|^sda|^sdb|^sdc" | awk '{print $1, $2, $3, $4}' >> $LOG_DIR/monitoramento_hardware.txt
}
```

---

## ✅ Resultado
Após rodar o script, o relatório `monitoramento_hardware.txt` conterá:
- Data/hora da execução
- Uso atual da memória RAM
- Uso da CPU
- Operações de leitura e escrita por dispositivo

🧠 **Dica:** Rodar esse script regularmente te dá uma visão real do desempenho da máquina. Ajuda muito a identificar lentidões, consumo exagerado ou possíveis gargalos! 🚨

---