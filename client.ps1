$url = "https://autohotkey.com/download/ahk.zip"
$dir = "$PSScriptRoot"
$zip = "$Home\Downloads\ahk.zip"
$exe = "$dir\AutoHotkeyU64.exe"
$pattern = "\AutoHotkeyU64.exe"
$lnk = "$dir\client.lnk"
$startup = [Environment]::GetFolderPath("Startup") + "\cross-notify.lnk"
$desktop = [Environment]::GetFolderPath("Desktop") + "\Cross Notify.lnk"

if (-not (Test-Path "$exe")) {
    if (-not (Test-Path $zip)) {
        Import-Module BitsTransfer
        Start-BitsTransfer -Description "Downloading $url" -Source $url -Destination $zip
    }
    $shell = New-Object -com Shell.Application
    $shell.NameSpace($zip).Items() | ? { $_.Path.EndsWith($pattern) } | % {
        $shell.NameSpace($dir).CopyHere($_)
    }
}

if (-not (Test-Path $lnk)) {
    $wscript = New-Object -ComObject ("WScript.Shell")
    $shortcut = $wscript.CreateShortcut($lnk)
    $shortcut.TargetPath="$exe"
    $shortcut.Arguments="AutoHotkey.txt"
    $shortcut.WorkingDirectory = "$dir"
    $shortcut.Save()
}

if (-not (Test-Path $startup)) {
    Copy-Item $lnk $startup
}

if (-not (Test-Path $desktop)) {
    Copy-Item $lnk $desktop
}

Invoke-Item -Path $lnk
