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