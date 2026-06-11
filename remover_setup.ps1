[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
function remover_warudo { 
    $confirm = Read-Host "Tem certeza que deseja remover as automações Warudo? (S/N)"
    if ($confirm -eq 'S') {
        (Get-Content $PROFILE) | Where-Object { $_ -notmatch 'ytmp4|ytmp3' } | Set-Content $PROFILE
        Write-Host "Automações removidas com sucesso! Reinicie o PowerShell." -ForegroundColor Green
    }
}