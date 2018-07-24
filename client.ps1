$url = "https://autohotkey.com/download/ahk.zip"
$dir = "$PSScriptRoot"
$zip = "$dir\ahk.zip"
$exe = "$dir\AutoHotkeyU64.exe"
$pattern = "\AutoHotkeyU64.exe"
$lnk = "$dir\client.lnk"
$startup = [environment]::getfolderpath("Startup") + "\cross-notify.lnk"

if (-not (Test-Path "$exe")) {
    if (-not (Test-Path $zip)) {
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $zip
    }
    $shell = new-object -com shell.application
    $shell.NameSpace($zip).Items() | ? { $_.Path.EndsWith($pattern) } | % {
        $shell.NameSpace($dir).copyhere($_)
    }
}

if (-not (Test-Path $lnk)) {
    $wscript = New-Object -ComObject ("WScript.Shell")
    $shortcut = $wscript.CreateShortcut($lnk)
    $shortcut.TargetPath="$exe"
    $shortcut.Arguments="AutoHotkey.txt"
    $shortcut.WorkingDirectory = "$dir";
    $shortcut.Save()
}

if (-not (Test-Path $startup)) {
    Copy-Item $lnk $startup
}

Invoke-Item -Path $lnk
