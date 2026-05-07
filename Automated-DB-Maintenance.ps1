# =================================================================
# SCRIPT DE BACKUP AUTOMATIZADO - ERP CONTABIL QUE UTILIZA DB FIREBIRD
# Objetivo: Parar o banco, compactar .fdb/.fbk e subir para o seu provedor de Nuvem
# =================================================================

# --- 1. CONFIGURAÇÃO DE CAMINHOS (Ajuste entre as aspas se necessário) ---
$Origem  = "C:\Caminho\Para\Seus\Dados\Firebird"          # Onde estão os arquivos .fdb
$Destino = "C:\Caminho\Para\Seu\Armazenamento\Backup"       # Pasta de destino no OneDrive
$Data    = Get-Date -Format "yyyy-MM-dd_HH-mm"    # Gera data e hora para o nome
$NomeArquivo = "Backup_Sistema_$Data.zip"

# --- 2. INÍCIO DO PROCESSO ---
Write-Host "--- Iniciando Rotina de Backup ---" -ForegroundColor Cyan

# Garante que a pasta de destino no OneDrive exista
if (!(Test-Path $Destino)) { 
    New-Item -ItemType Directory -Path $Destino 
    Write-Host "Pasta de destino criada no ARMAZENAMENTO EM NUVEM." -ForegroundColor Gray
}

# --- 3. PARADA DO BANCO DE DADOS ---
# O -ErrorAction SilentlyContinue evita erros se o serviço já estiver parado
Write-Host "Pausando o serviço Firebird para garantir integridade..." -ForegroundColor Yellow
Stop-Service -Name "Firebird*" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2 # Pequena pausa para o Windows liberar os arquivos

# --- 4. COMPACTAÇÃO (Versão corrigida e compatível) ---
Write-Host "Buscando e compactando arquivos .fdb e .fbk..." -ForegroundColor Cyan

# Primeiro, selecionamos os arquivos desejados
$ArquivosFiltrados = Get-ChildItem -Path "$Origem\*" -Include *.fdb, *.fbk -Recurse

# Se encontrar arquivos, compacta. Se não, avisa.
if ($ArquivosFiltrados) {
    Compress-Archive -Path $ArquivosFiltrados.FullName -DestinationPath "$Destino\$NomeArquivo" -Force
    Write-Host "Compactação concluída com $($ArquivosFiltrados.Count) arquivos." -ForegroundColor Gray
} else {
    Write-Host "AVISO: Nenhum arquivo .fdb ou .fbk foi localizado em $Origem" -ForegroundColor Red
}


# --- 5. REINICIALIZAÇÃO DO SERVIÇO ---
Write-Host "Reiniciando o serviço Firebird..." -ForegroundColor Green
Start-Service -Name "Firebird*" -ErrorAction SilentlyContinue

# --- 6. FINALIZAÇÃO ---
Write-Host "----------------------------------------------"
Write-Host "BACKUP CONCLUÍDO COM SUCESSO!" -ForegroundColor White -BackgroundColor Green
Write-Host "Arquivo: $NomeArquivo"
Write-Host "O Provedor de armazenamento iniciará o upload automaticamente."
Write-Host "----------------------------------------------"

# --- 7. LIMPEZA DE BACKUPS ANTIGOS (Retenção de 7 dias) ---
Write-Host "Limpando backups com mais de 7 dias no OneDrive..." -ForegroundColor Cyan

$LimiteDias = (Get-Date).AddDays(-7)

# Busca arquivos .zip na pasta de destino que foram criados há mais de 7 dias
$ArquivosAntigos = Get-ChildItem -Path $Destino -Filter "*.zip" | Where-Object { $_.CreationTime -lt $LimiteDias }

if ($ArquivosAntigos) {
    foreach ($Arq in $ArquivosAntigos) {
        Remove-Item $Arq.FullName -Force
        Write-Host "Arquivo removido: $($Arq.Name)" -ForegroundColor Gray
    }
    Write-Host "Limpeza concluída." -ForegroundColor Green
} else {
    Write-Host "Nenhum arquivo antigo para remover." -ForegroundColor Gray
}
