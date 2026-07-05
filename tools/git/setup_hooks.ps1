Write-Host "Configuring Git to use .githooks directory..."
git config core.hooksPath .githooks
Write-Host "Git hooks configured successfully! Commits will now automatically run formatting and linting checks."
