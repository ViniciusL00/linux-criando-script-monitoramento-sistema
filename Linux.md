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