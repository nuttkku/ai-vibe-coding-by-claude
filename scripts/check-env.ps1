# Pre-course environment check for Windows.
# Usage (PowerShell):  powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
# Works on Windows PowerShell 5.1 and PowerShell 7+. Read-only: changes nothing on the machine.

$ErrorActionPreference = 'SilentlyContinue'
$results = New-Object System.Collections.ArrayList

function Add-Result($status, $name, $detail) {
    [void]$results.Add([pscustomobject]@{ Status = $status; Check = $name; Detail = $detail })
}

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# --- Hardware -----------------------------------------------------------------
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
if ($ramGB -ge 16) { Add-Result 'PASS' 'RAM' "$ramGB GB" }
elseif ($ramGB -ge 8) { Add-Result 'WARN' 'RAM' "$ramGB GB (16 GB recommended to run Docker Desktop and a VM together)" }
else { Add-Result 'FAIL' 'RAM' "$ramGB GB (at least 8 GB required, 16 GB recommended)" }

$sysDrive = $env:SystemDrive.TrimEnd(':')
$freeGB = [math]::Round((Get-PSDrive $sysDrive).Free / 1GB)
if ($freeGB -ge 60) { Add-Result 'PASS' 'Free disk' "$freeGB GB on $($env:SystemDrive)" }
elseif ($freeGB -ge 30) { Add-Result 'WARN' 'Free disk' "$freeGB GB on $($env:SystemDrive) (60 GB recommended)" }
else { Add-Result 'FAIL' 'Free disk' "$freeGB GB on $($env:SystemDrive) (need at least 30 GB)" }

# When Hyper-V/WSL2 is already running, firmware virtualization reports False but a hypervisor is present.
$hypervisor = (Get-CimInstance Win32_ComputerSystem).HypervisorPresent
$vtFirmware = (Get-CimInstance Win32_Processor | Select-Object -First 1).VirtualizationFirmwareEnabled
if ($hypervisor -or $vtFirmware) { Add-Result 'PASS' 'Virtualization' 'enabled' }
else { Add-Result 'FAIL' 'Virtualization' 'disabled - enable Intel VT-x / AMD-V (SVM) in BIOS/UEFI' }

# --- Tools --------------------------------------------------------------------
if (Test-Command git) { Add-Result 'PASS' 'Git' ((git --version) -join ' ') }
else { Add-Result 'FAIL' 'Git' 'not found - https://git-scm.com/download/win' }

if (Test-Command node) {
    $nodeVer = (node -v)
    $major = [int]($nodeVer.TrimStart('v').Split('.')[0])
    if ($major -ge 20 -and ($major % 2 -eq 0)) { Add-Result 'PASS' 'Node.js' $nodeVer }
    else { Add-Result 'WARN' 'Node.js' "$nodeVer (install the current LTS from https://nodejs.org)" }
} else { Add-Result 'FAIL' 'Node.js' 'not found - install LTS from https://nodejs.org' }

if (Test-Command npm) { Add-Result 'PASS' 'npm' (npm -v) }
else { Add-Result 'FAIL' 'npm' 'not found (comes with Node.js; reopen the terminal after installing)' }

if (Test-Command code) { Add-Result 'PASS' 'VS Code' 'code command found' }
else { Add-Result 'WARN' 'VS Code' "'code' not on PATH - install VS Code or enable 'Add to PATH'" }

if (Test-Command claude) { Add-Result 'PASS' 'Claude Code CLI' ((claude --version) -join ' ') }
else { Add-Result 'WARN' 'Claude Code CLI' 'not found (optional if you use the VS Code extension)' }

$ghDesktop = Test-Path "$env:LOCALAPPDATA\GitHubDesktop\GitHubDesktop.exe"
if ($ghDesktop) { Add-Result 'PASS' 'GitHub Desktop' 'installed' }
else { Add-Result 'WARN' 'GitHub Desktop' 'not found (optional if you use git on the command line)' }

# --- WSL2 ---------------------------------------------------------------------
if (Test-Command wsl) {
    $wslStatus = (wsl --status 2>&1 | Out-String) -replace "`0", ''
    if ($wslStatus -match 'Default Version:\s*2' -or $wslStatus -match ':\s*2\s*$') { Add-Result 'PASS' 'WSL2' 'default version 2' }
    elseif ($LASTEXITCODE -eq 0) { Add-Result 'WARN' 'WSL2' 'installed, could not confirm default version 2 - run: wsl --set-default-version 2' }
    else { Add-Result 'FAIL' 'WSL2' 'not installed - run as Administrator: wsl --install' }
} else { Add-Result 'FAIL' 'WSL2' 'not installed - run as Administrator: wsl --install' }

# --- Docker -------------------------------------------------------------------
if (Test-Command docker) {
    docker info *> $null
    if ($LASTEXITCODE -eq 0) { Add-Result 'PASS' 'Docker engine' ((docker version --format '{{.Server.Version}}') -join ' ') }
    else { Add-Result 'FAIL' 'Docker engine' 'installed but not running - start Docker Desktop' }
    docker compose version *> $null
    if ($LASTEXITCODE -eq 0) { Add-Result 'PASS' 'Docker Compose' ((docker compose version --short) -join ' ') }
    else { Add-Result 'FAIL' 'Docker Compose' 'compose plugin not found - update Docker Desktop' }
} else { Add-Result 'FAIL' 'Docker' 'not found - https://www.docker.com/products/docker-desktop/' }

# --- VirtualBox ---------------------------------------------------------------
$vbox = $null
if (Test-Command VBoxManage) { $vbox = 'VBoxManage' }
elseif (Test-Path "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe") { $vbox = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" }
if ($vbox) {
    Add-Result 'PASS' 'VirtualBox' ((& $vbox --version) -join ' ')
    $vms = (& $vbox list vms) -join "`n"
    if ($vms -match 'vibe-server') { Add-Result 'PASS' 'Course VM' "'vibe-server' exists" }
    else { Add-Result 'WARN' 'Course VM' "'vibe-server' not created yet (done on Day 4)" }
} else { Add-Result 'FAIL' 'VirtualBox' 'not found - https://www.virtualbox.org/wiki/Downloads' }

$iso = Get-ChildItem "$env:USERPROFILE\Downloads" -Filter 'ubuntu-*-live-server-*.iso' | Select-Object -First 1
if ($iso) { Add-Result 'PASS' 'Ubuntu Server ISO' $iso.Name }
else { Add-Result 'WARN' 'Ubuntu Server ISO' 'not found in Downloads - https://ubuntu.com/download/server' }

# --- Ports used in the labs ---------------------------------------------------
foreach ($port in 5173, 8080, 5432) {
    $busy = Get-NetTCPConnection -State Listen -LocalPort $port
    if ($busy) {
        $proc = (Get-Process -Id ($busy | Select-Object -First 1).OwningProcess).ProcessName
        Add-Result 'WARN' "Port $port" "in use by $proc (labs can use another port via .env)"
    } else { Add-Result 'PASS' "Port $port" 'free' }
}

# --- Network ------------------------------------------------------------------
foreach ($h in 'github.com', 'registry-1.docker.io', 'claude.ai', 'api.trycloudflare.com') {
    $ok = Test-NetConnection $h -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($ok) { Add-Result 'PASS' "Reach $h" 'ok' } else { Add-Result 'FAIL' "Reach $h" 'blocked - check proxy/firewall' }
}

# --- Report -------------------------------------------------------------------
$colors = @{ PASS = 'Green'; WARN = 'Yellow'; FAIL = 'Red' }
Write-Host ''
Write-Host 'AI Vibe Coding with Claude - environment check' -ForegroundColor Cyan
Write-Host ('-' * 60)
foreach ($r in $results) {
    Write-Host ('[{0}] ' -f $r.Status) -ForegroundColor $colors[$r.Status] -NoNewline
    Write-Host ('{0,-26} {1}' -f $r.Check, $r.Detail)
}
$fail = @($results | Where-Object Status -eq 'FAIL').Count
$warn = @($results | Where-Object Status -eq 'WARN').Count
Write-Host ('-' * 60)
Write-Host ("{0} FAIL, {1} WARN" -f $fail, $warn)
if ($fail -gt 0) { Write-Host 'Fix FAIL items before Day 2. See day-1-intro/README.md' -ForegroundColor Red; exit 1 }
Write-Host 'Ready for Day 2.' -ForegroundColor Green
exit 0
