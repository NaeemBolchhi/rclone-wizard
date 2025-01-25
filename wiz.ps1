# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$DownloadBAT = 'https://naeembolchhi.github.io/rclone-wizard/wiz-20250025185546.bat'
$DownloadICON1 = 'https://naeembolchhi.github.io/rclone-wizard/mount.ico'
$DownloadICON2 = 'https://naeembolchhi.github.io/rclone-wizard/unmount.ico'

$folderPath = "$env:ProgramData\TmFlZW1Cb2xjaGhp"
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
}

$FilePath = "$folderPath\wiz.bat"
$IconPath1 = "$folderPath\mount.ico"
$IconPath2 = "$folderPath\unmount.ico"

try {
    Invoke-WebRequest -Uri $DownloadBAT -UseBasicParsing -OutFile $FilePath
	Invoke-WebRequest -Uri $DownloadICON1 -UseBasicParsing -OutFile $IconPath1
	Invoke-WebRequest -Uri $DownloadICON2 -UseBasicParsing -OutFile $IconPath2
} catch {
    Write-Error $_
	Return
}

if (Test-Path $FilePath) {
    Start-Process $FilePath -Wait
    # $item = Get-Item -LiteralPath $FilePath
    # $item.Delete()
}
