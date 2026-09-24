# EventSphere Build Script
param (
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

$projectRoot = $PSScriptRoot
$srcJava = Join-Path $projectRoot "src\main\java"
$classesDir = Join-Path $projectRoot "src\main\webapp\WEB-INF\classes"
$tomcatLib = "D:\dev_tools\apache-tomcat-10\lib\*"
$appLib = Join-Path $projectRoot "src\main\webapp\WEB-INF\lib\*"
$javac = "D:\dev_tools\jdk-17\bin\javac.exe"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Building EventSphere Platform" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if ($Clean -and (Test-Path $classesDir)) {
    Write-Host "Cleaning classes directory..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $classesDir
}

if (-not (Test-Path $classesDir)) {
    New-Item -ItemType Directory -Path $classesDir -Force | Out-Null
}

$javaFiles = Get-ChildItem -Path $srcJava -Filter "*.java" -Recurse | ForEach-Object { $_.FullName }
Write-Host "Found $($javaFiles.Count) Java source files." -ForegroundColor Green

$sourcesListFile = Join-Path $projectRoot "sources.txt"
$javaFiles | Out-File -FilePath $sourcesListFile -Encoding ascii

$cp = "$tomcatLib;$appLib"

Write-Host "Compiling Java classes..." -ForegroundColor Cyan
& $javac -encoding UTF-8 -cp $cp -d $classesDir "@$sourcesListFile"

if ($LASTEXITCODE -eq 0) {
    Remove-Item $sourcesListFile -Force -ErrorAction SilentlyContinue
    Write-Host "[SUCCESS] Compilation completed successfully with 0 errors!" -ForegroundColor Green
    Write-Host "Classes output: $classesDir" -ForegroundColor Gray
} else {
    Write-Host "[ERROR] Compilation failed with exit code $LASTEXITCODE." -ForegroundColor Red
    exit 1
}
