<#
.SYNOPSIS
    Script de Setup Automatizado do Aráudo Tech - Otimizado
#>

# Define a codificação para UTF-8 para exibição correta de acentuação
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::InputEncoding = [System.Text.Encoding]::UTF8

Write-Host "--- Script de Setup Automatizado do Araúdo Tech ---" -ForegroundColor Yellow

# Verifica se o Winget já está instalado antes de baixar
Write-Host "Verificando o Winget..." -ForegroundColor Cyan
if (Get-Command -Name winget -ErrorAction SilentlyContinue) {
    Write-Host "Winget já está instalado no sistema. Pulando download." -ForegroundColor Green
} else {
    Write-Host "Baixando e instalando o Winget..." -ForegroundColor Cyan
    try {
        $installer = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile $installer -ErrorAction Stop
        Add-AppxPackage $installer -ErrorAction Stop
        Remove-Item $installer -Force
    } catch {
        Write-Host "Falha ao instalar o Winget automaticamente. Instale o 'Instalador de App' (App Installer) pela Microsoft Store." -ForegroundColor Red
        Exit
    }
}
Start-Sleep -Seconds 2

# Confirmação para instalação do Firefox
$confirmFirefox = Read-Host "Deseja instalar o Navegador Firefox? (Recomendado) (S/N)"
if ($confirmFirefox -eq 'S' -or $confirmFirefox -eq 's') {
    Write-Host "Instalando Firefox..." -ForegroundColor Cyan
    try {
        winget install -e --id Mozilla.Firefox.ESR -ErrorAction Stop
    } catch {
        Write-Host "Falha na instalação do Firefox via Winget." -ForegroundColor Red
    }
} else {
    Write-Host "Instalação do Firefox ignorada." -ForegroundColor Yellow
}
Start-Sleep -Seconds 2

# Instalação do yt-dlp
Write-Host "Instalando o yt-dlp..." -ForegroundColor Cyan
try {
    winget install -e --id yt-dlp.yt-dlp -ErrorAction Stop
} catch {
    Write-Host "Falha na instalação do yt-dlp via Winget." -ForegroundColor Red
}
Start-Sleep -Seconds 2

# Aviso sobre autenticação e cookies
Write-Host "--- AVISO IMPORTANTE ---" -ForegroundColor Red
Write-Host "Vídeos com restrição de idade ou conteúdos privados precisam de autenticação!" -ForegroundColor White
Write-Host "Certifique-se de usar as funções '_ck' (que utilizam Cookies do Firefox) para baixar esse tipo de conteúdo!" -ForegroundColor White
Write-Host "Caso contrário, o download irá falhar." -ForegroundColor Red
[void][System.Console]::ReadKey($true)

# Configuração do Perfil do PowerShell
Write-Host "Configurando o seu perfil do PowerShell..." -ForegroundColor Cyan

if (!(Test-Path -Path $PROFILE)) { 
    New-Item -Type File -Path $PROFILE -Force | Out-Null
}

# Funções otimizadas para o perfil
$functions = @'

function ytmp4 { yt-dlp -o "$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --sleep-interval 5 --max-sleep-interval 15 -f "bestvideo+bestaudio/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata $args }
function ytmp4_ck { yt-dlp -o "$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:perfil --sleep-interval 5 --max-sleep-interval 15 -f "bestvideo+bestaudio/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata $args }
function ytmp3 { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\mp3\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata $args }
function ytmp3_ck { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\mp3\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:perfil --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata $args }
function ytflac { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\flac\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --sleep-interval 5 --max-sleep-interval 15 -x --audio-format flac --embed-thumbnail --embed-metadata $args }
function ytflac_ck { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\flac\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:perfil --sleep-interval 5 --max-sleep-interval 15 -x --audio-format flac --embed-thumbnail --embed-metadata $args }

'@

# Adiciona as funções ao arquivo de perfil existente sem sobrescrever o que já estiver lá
Add-Content -Path $PROFILE -Value $functions

Write-Host "Feito! Reinicie o PowerShell para aplicar as alterações." -ForegroundColor Green
