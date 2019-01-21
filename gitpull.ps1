$jpcommand = Get-Command git.exe | Select-Object -ExpandProperty Definition

if($jpcommand -eq $null){
    Write-Output "Could not find git.exe in environment path"
    Break
}

Write-Output $jpcommand

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

function createRegedit([string]$registryPath, [string]$value)
{
    $name = "(Default)"

    If(!(Test-Path $registryPath)){
        New-Item -Path $registryPath -Force | Out-Null    
    }
    
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
        -PropertyType String -Force | Out-Null    
}

$openText = "Git Pull here"

createRegedit "HKCR:\Directory\Background\shell\git" $openText
createRegedit "HKCR:\Directory\shell\git" $openText
#git.exe pull -v --progress "origin"
$commandText = "`"" + $jpcommand + "`"--work-tree=`"%V`" --git-dir=`"%V/.git`" pull -v --progress"

createRegedit "HKCR:\Directory\Background\shell\git\command" $commandText
createRegedit "HKCR:\Directory\shell\git\command" $commandText

$currentPath = (Get-Item -Path ".\" -Verbose).FullName

#change to favicon-notebook.ico for alternative icon
$jpicon = "$($currentPath)\gitfavicon.ico"

#set icons
New-ItemProperty -Path "HKCR:\Directory\Background\shell\git" -Name "Icon" -Value $jpicon `
        -PropertyType String -Force | Out-Null    

New-ItemProperty -Path "HKCR:\Directory\shell\git" -Name "Icon" -Value $jpicon `
        -PropertyType String -Force | Out-Null  
