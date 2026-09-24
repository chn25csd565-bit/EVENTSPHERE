# EventSphere Startup Script
param (
    [switch]$Foreground,
    [switch]$Rebuild
)

$ErrorActionPreference = "Stop"

$projectRoot = "c:\Users\Joys\EVENTSPHERE"
$tomcatHome = "D:\dev_tools\apache-tomcat-10"
$javaHome = "D:\dev_tools\jdk-17"
$webAppDir = "$projectRoot\src\main\webapp"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Starting EventSphere Platform" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Compile Java code if needed
$classesDir = Join-Path $webAppDir "WEB-INF\classes\com\eventsphere\controller"
if ($Rebuild -or (-not (Test-Path $classesDir))) {
    Write-Host "Compiling application classes..." -ForegroundColor Yellow
    & powershell -File "$projectRoot\build.ps1"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed. Aborting startup." -ForegroundColor Red
        exit 1
    }
}

# 2. Configure Tomcat context
$confCat = "$tomcatHome\conf\Catalina\localhost"
if (-not (Test-Path $confCat)) {
    New-Item -ItemType Directory -Path $confCat -Force | Out-Null
}

$contextXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<Context docBase="$($webAppDir.Replace('\', '/'))" reloadable="true">
</Context>
"@

Set-Content -Path "$confCat\ROOT.xml" -Value $contextXml -Encoding UTF8
Set-Content -Path "$confCat\eventsphere.xml" -Value $contextXml -Encoding UTF8
Write-Host "Tomcat context mapped to: $webAppDir" -ForegroundColor Gray

# 3. Environment Variables
$env:JAVA_HOME = $javaHome
$env:CATALINA_HOME = $tomcatHome
$env:PATH = "$javaHome\bin;$env:PATH"

# 4. Check if Tomcat is already running on port 8080
$portInUse = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "Port 8080 is currently occupied. Stopping existing instance..." -ForegroundColor Yellow
    & "$tomcatHome\bin\shutdown.bat" 2>$null
    Start-Sleep -Seconds 3
    # If still listening, kill process
    $portInUse = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
    if ($portInUse) {
        Stop-Process -Id $portInUse.OwningProcess -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# 5. Launch Tomcat
if ($Foreground) {
    Write-Host "Launching Tomcat in foreground on http://localhost:8080/..." -ForegroundColor Green
    & "$tomcatHome\bin\catalina.bat" run
} else {
    Write-Host "Launching Tomcat in background..." -ForegroundColor Green
    & "$tomcatHome\bin\catalina.bat" start
    Start-Sleep -Seconds 3
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "  EventSphere is LIVE!" -ForegroundColor Green
    Write-Host "  Direct URL:   http://localhost:8080/" -ForegroundColor Cyan
    Write-Host "  Context URL:  http://localhost:8080/eventsphere/" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Green
}
