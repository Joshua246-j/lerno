Write-Host "Building Lerno for release with code obfuscation..."

# Ensure we have a debug_info directory
$debugInfoDir = ".\build\app\outputs\symbols"
if (-not (Test-Path -Path $debugInfoDir)) {
    New-Item -ItemType Directory -Force -Path $debugInfoDir | Out-Null
}

# Run the flutter build apk command with obfuscation flags
# --obfuscate hides the source code names to prevent reverse engineering
# --split-debug-info saves the mapping symbols so you can decode crash reports later
flutter build apk --release --obfuscate --split-debug-info=$debugInfoDir

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build completed successfully! APK is located at .\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Green
    Write-Host "Keep the symbols safely backed up from $debugInfoDir to symbolicate future crash reports." -ForegroundColor Yellow
} else {
    Write-Host "Build failed. Check the error above." -ForegroundColor Red
}
