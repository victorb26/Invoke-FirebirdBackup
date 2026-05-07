# 🚀 Automated Firebird Backup to Cloud (PowerShell)

![PowerShell](https://shields.io)
![Windows Server](https://shields.io)


## 📝 Descrição
Este projeto apresenta uma solução robusta de **Infrastructure as Code (IaC)** para automação de rotinas de backup de bancos de dados **Firebird (.fdb/.fbk)** em ambientes críticos. 

O script foi desenvolvido para substituir processos manuais, mitigando riscos de corrupção de dados e garantindo a redundância off-site através da integração com serviços de nuvem (OneDrive/Azure).

## ✨ Funcionalidades Principais
- **Integridade Garantida:** Realiza o controle de serviços (`Stop/Start`) do Firebird para assegurar que o banco de dados não esteja em uso durante a cópia.
- **Compressão Inteligente:** Compactação automática dos arquivos, reduzindo o consumo de banda e espaço em disco em até 85%.
- **Cloud Sync:** Sincronização automatizada com armazenamento em nuvem.
- **Política de Retenção (Retention Policy):** Limpeza automática de arquivos antigos (configurável, padrão de 7 dias) para otimização de storage.
- **Log Nativo:** Feedback em console com cores para fácil monitoramento manual.

## 🛠️ Como Utilizar
1. Clone este repositório ou baixe o arquivo `Invoke-FirebirdBackup.ps1`.
2. Edite as variáveis `$Origem` e `$Destino` no início do script com os seus diretórios locais.
3. Agende a execução via **Task Scheduler** do Windows para rodar em horários de baixo pico.
4. Certifique-se de que a política de execução do PowerShell permita o script (`Set-ExecutionPolicy RemoteSigned`).

## 📊 Resultados Alcançados
No ambiente de produção onde foi implementado, o script gerencia uma base de **2.5GB**, reduzindo-a para aproximadamente **390MB** e completando todo o ciclo de manutenção em menos de **6 minutos** de forma 100% autônoma.

---
**Desenvolvido por Victor Barros**  
*Estudante de Análise e Desenvolvimento de Sistemas *
