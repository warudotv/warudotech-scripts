Write-Host "Baixando e instalando o Winget..." -ForegroundColor Cyan
$installer = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile $installer
Add-AppxPackage $installer

Remove-Item $installer -Force

Write-Host "Instalando o yt-dlp via Winget..." -ForegroundColor Cyan
winget install yt-dlp.yt-dlp

Write-Host "Configurando o seu perfil do PowerShell..." -ForegroundColor Cyan
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force };

$browser = "chrome"

$functions = @'
function ytmp4 { yt-dlp -o "`$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -S "vcodec:h264,res,acodec:m4a" --embed-thumbnail --embed-metadata --merge-output-format mp4 `$args }
function ytmp4_ck { yt-dlp --cookies-from-browser $browser -o "`$env:USERPROFILE\Videos\ytdlp\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -S "vcodec:h264,res,acodec:m4a" --embed-thumbnail --embed-metadata --merge-output-format mp4 `$args }
function ytmp3_320 { yt-dlp -o "`$env:USERPROFILE\Music\ytdlp\320k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 320K --ppa "ExtractAudio:-ar 48000" --embed-thumbnail --embed-metadata `$args }
function ytmp3_320_ck { yt-dlp --cookies-from-browser $browser -o "`$env:USERPROFILE\Music\ytdlp\320k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 320K --ppa "ExtractAudio:-ar 48000" --embed-thumbnail --embed-metadata `$args }
function ytmp3_128 { yt-dlp -o "`$env:USERPROFILE\Music\ytdlp\128k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 128K --embed-thumbnail --embed-metadata `$args }
function ytmp3_128_ck { yt-dlp --cookies-from-browser $browser -o "`$env:USERPROFILE\Music\ytdlp\128k\%(playlist_title,uploader)s/%(title)s - %(uploader)s.%(ext)s" --windows-filenames --sleep-interval 5 --max-sleep-interval 15 -x --audio-format mp3 --audio-quality 128K --embed-thumbnail --embed-metadata `$args }
'@

$functions | Out-File -FilePath $PROFILE -Append
Write-Host "Ok! Reinicie o PowerShell." -ForegroundColor Green
