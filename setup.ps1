[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
Write-Host "--- Script de Setup Automatizado do WARUDO ---" -ForegroundColor Yellow

Write-Host "Baixando e instalando o Winget..." -ForegroundColor Cyan
$installer = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile $installer
Add-AppxPackage $installer
Remove-Item $installer -Force
Start-Sleep -Seconds 3

$confirmFirefox = Read-Host "Deseja instalar o Navegador Firefox? (Recomendado) (S/N)"
if ($confirmFirefox -eq 'S' -or $confirmFirefox -eq 's') {
    Write-Host "Instalando Firefox..." -ForegroundColor Cyan
    winget install -e --id Mozilla.Firefox.ESR
} else {
    Write-Host "Instalacao do Firefox ignorada." -ForegroundColor Yellow
}
Start-Sleep -Seconds 3

Write-Host "Instalando o yt-dlp e suas dependencias..." -ForegroundColor Cyan
winget install yt-dlp.yt-dlp Gyan.FFmpeg denoland.deno
Start-Sleep -Seconds 3

Write-Host "--- AVISO IMPORTANTE ---" -ForegroundColor Red
Write-Host " Vídeos com restrição de idade Ou o conteúdos Privados precisam de autenticação!"
Write-Host "Certifique-se usar '_ck' (que utilizam Cookies do Firefox) para baixar esse tipo de Conteúdo!"
Write-Host " Caso contrário, o download irá falhar." -ForegroundColor Red
Read-Host "Pressione ENTER para Concluir!"

Write-Host "Configurando o seu perfil do PowerShell..." -ForegroundColor Cyan
Start-Sleep -Seconds 3
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force };

$functions = @'
function ytmp4 { yt-dlp -o "$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -S "vcodec:h264,res,acodec:m4a" --embed-thumbnail --embed-metadata --merge-output-format mp4 $args }
function ytmp4_ck { yt-dlp -o "$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:default-release --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -S "vcodec:h264,res,acodec:m4a" --embed-thumbnail --embed-metadata --merge-output-format mp4 $args }
function ytmp3_320 { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\320k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 320K --ppa "ExtractAudio:-ar 48000" --embed-thumbnail --embed-metadata $args }
function ytmp3_320_ck { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\320k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:default-release --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 320K --ppa "ExtractAudio:-ar 48000" --embed-thumbnail --embed-metadata $args }
function ytmp3_128 { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\128k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 128K --embed-thumbnail --embed-metadata $args }
function ytmp3_128_ck { yt-dlp -o "$env:USERPROFILE\Music\ytdlp\128k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --cookies-from-browser firefox:default-release --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 128K --embed-thumbnail --embed-metadata $args }
'@

$functions | Out-File -FilePath $PROFILE -Append
Start-Sleep -Seconds 3
Write-Host "Feito! Reinicie o PowerShell." -ForegroundColor Green
