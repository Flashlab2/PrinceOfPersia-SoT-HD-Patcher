$ErrorActionPreference = "Stop"
$ExpectedOriginal = "6587D499F4EA6D0895179F74487045BC2C82A9D4E08A0A5046C1FB88EE3B6EC9"
$ExpectedPatched  = "A47848788CCC234DC65683B02D4277462854377684430A89CFB639DCF4E0635C"
$Exe = Join-Path $PSScriptRoot "POP.EXE"
$Backup = Join-Path $PSScriptRoot "POP.EXE.bak"
function Get-Sha256([string]$Path) { (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToUpperInvariant() }
Write-Host ""
Write-Host "Prince of Persia: The Sands of Time - HD Cutscenes EXE Patcher"
Write-Host "----------------------------------------------------------------"
if (-not (Test-Path -LiteralPath $Exe)) { Write-Host "ERROR: POP.EXE was not found next to this patcher." -ForegroundColor Red; exit 1 }
$hash=Get-Sha256 $Exe; Write-Host "Detected SHA-256: $hash"
if ($hash -eq $ExpectedPatched) { Write-Host "POP.EXE is already patched." -ForegroundColor Green; exit 0 }
if ($hash -ne $ExpectedOriginal) { Write-Host "ERROR: Unsupported POP.EXE. No changes made." -ForegroundColor Red; exit 2 }
if (-not (Test-Path -LiteralPath $Backup)) { Copy-Item -LiteralPath $Exe -Destination $Backup; Write-Host "Backup created: POP.EXE.bak" } else { Write-Host "Existing backup preserved: POP.EXE.bak" }
[byte[]]$bytes=[System.IO.File]::ReadAllBytes($Exe)
if ($bytes[0x156] -ne 0x0F -or $bytes[0x274D45] -ne 0x2B -or $bytes[0x274D46] -ne 0xC6) { Write-Host "ERROR: Expected bytes not found. No changes written." -ForegroundColor Red; exit 3 }
$bytes[0x156]=0x2F; $bytes[0x274D45]=0x31; $bytes[0x274D46]=0xC0
[System.IO.File]::WriteAllBytes($Exe,$bytes)
$newHash=Get-Sha256 $Exe; Write-Host "Patched SHA-256: $newHash"
if ($newHash -ne $ExpectedPatched) { Write-Host "ERROR: Verification failed. Restoring backup." -ForegroundColor Red; Copy-Item -LiteralPath $Backup -Destination $Exe -Force; exit 4 }
Write-Host "SUCCESS: POP.EXE matches the verified HD-video executable." -ForegroundColor Green
Write-Host "Backup: POP.EXE.bak"
