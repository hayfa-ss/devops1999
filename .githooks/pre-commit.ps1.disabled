#!/usr/bin/env pwsh
# PowerShell pre-commit hook (versioned) to detect common secret patterns

# Get staged files
$staged = git diff --cached --name-only
$found = $false

foreach ($f in $staged) {
    if (Test-Path $f) {
        # Skip versioned hooks themselves
        if ($f -like '.githooks*') { continue }

        if (Select-String -Path $f -Pattern 'password\s*=' -SimpleMatch -Quiet) {
            Write-Host "ERROR: potential secret found in $f (pattern: password = ...)"
            $found = $true
        }
        if (Select-String -Path $f -Pattern 'api[_-]?key|token|secret' -Quiet) {
            Write-Host "ERROR: potential secret found in $f (pattern: api key / token / secret)"
            $found = $true
        }
    }
}

if ($found) {
    Write-Host "Pre-commit failed: secrets detected. Remove or mask secrets, then re-stage."
    exit 1
}
exit 0
