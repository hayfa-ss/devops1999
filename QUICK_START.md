# 🚀 Quick Start Guide - Timesheet DevOps

## ⚠️ IMPORTANT: Use the CORRECT URL!

### ❌ These URLs will give 404 Error:
```
http://localhost:8082
http://localhost:8082/timesheet-devops
http://localhost:8082/timesheet-devops/
```

### ✅ These URLs WORK:

#### 1. Get All Users
```
http://localhost:8082/timesheet-devops/user/retrieve-all-users
```
**What you'll see:** JSON array of users (might be empty `[]` if no users)

#### 2. Get User by ID
```
http://localhost:8082/timesheet-devops/user/retrieve-user/1
```
Replace `1` with any user ID

#### 3. Add User (POST - use Postman or PowerShell)
```
http://localhost:8082/timesheet-devops/user/add-user
```

#### 4. Update User (PUT - use Postman or PowerShell)
```
http://localhost:8082/timesheet-devops/user/modify-user
```

#### 5. Delete User (DELETE - use Postman or PowerShell)
```
http://localhost:8082/timesheet-devops/user/remove-user/1
```

---

## 📋 Quick Test Steps

### Step 1: Test in Browser
1. Open your browser
2. Copy and paste this EXACT URL:
   ```
   http://localhost:8082/timesheet-devops/user/retrieve-all-users
   ```
3. You should see JSON data (empty array `[]` or list of users)

### Step 2: Use the Test Page
1. Open `test-api.html` in your browser (double-click the file)
2. Click "Get All Users" button
3. You should see the data displayed

### Step 3: Add a User (PowerShell)
```powershell
$user = @{
    firstName = "Test"
    lastName = "User"
    dateNaissance = "1990-01-01"
    role = "INGENIEUR"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8082/timesheet-devops/user/add-user" -Method POST -Body $user -ContentType "application/json"
```

---

## 🔍 Troubleshooting

### Problem: Still getting 404?
**Solution:** Make sure you're using the FULL URL:
- ✅ `http://localhost:8082/timesheet-devops/user/retrieve-all-users`
- ❌ NOT `http://localhost:8082`

### Problem: Application not running?
**Solution:** Start it with:
```powershell
mvn spring-boot:run
```

### Problem: Database connection error?
**Solution:** 
1. Make sure XAMPP MySQL is running
2. Check `application.properties` has correct database name: `timesheet_devops_db`

---

## 📝 URL Pattern

All working URLs follow this pattern:
```
http://localhost:8082/timesheet-devops/user/{endpoint}
```

Where `{endpoint}` can be:
- `retrieve-all-users`
- `retrieve-user/{id}`
- `add-user`
- `modify-user`
- `remove-user/{id}`

---

## ✅ Success Indicators

When it's working, you'll see:
- JSON data in browser (not HTML error page)
- Status 200 (not 404)
- Data displayed in test-api.html page

