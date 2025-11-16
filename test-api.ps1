# Test Script for Timesheet DevOps API

Write-Host "=== Timesheet DevOps API Test ===" -ForegroundColor Green
Write-Host ""

# Base URL
$baseUrl = "http://localhost:8082/timesheet-devops"

# 1. Get all users
Write-Host "1. Getting all users..." -ForegroundColor Yellow
try {
    $users = Invoke-RestMethod -Uri "$baseUrl/user/retrieve-all-users" -Method GET
    Write-Host "   Users found: $($users.Count)" -ForegroundColor Cyan
    $users | ConvertTo-Json
} catch {
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 2. Add a test user
Write-Host "2. Adding a test user..." -ForegroundColor Yellow
$newUser = @{
    firstName = "John"
    lastName = "Doe"
    dateNaissance = "1990-01-15"
    role = "CHEF_DEPARTEMENT"
} | ConvertTo-Json

try {
    $addedUser = Invoke-RestMethod -Uri "$baseUrl/user/add-user" -Method POST -Body $newUser -ContentType "application/json"
    Write-Host "   User added successfully!" -ForegroundColor Green
    $addedUser | ConvertTo-Json
} catch {
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 3. Get all users again
Write-Host "3. Getting all users again..." -ForegroundColor Yellow
try {
    $users = Invoke-RestMethod -Uri "$baseUrl/user/retrieve-all-users" -Method GET
    Write-Host "   Users found: $($users.Count)" -ForegroundColor Cyan
    $users | ConvertTo-Json
} catch {
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Test Complete ===" -ForegroundColor Green

