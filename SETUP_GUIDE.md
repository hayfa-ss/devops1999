# Setup Guide - Timesheet DevOps Application

## Prerequisites Check
✅ Java 17 is installed  
✅ Maven 3.9.9 is installed  
⚠️ MySQL needs to be checked

## Step-by-Step Setup Instructions

### 1. Install and Setup MySQL Database

If MySQL is not installed:
- Download MySQL from: https://dev.mysql.com/downloads/installer/
- Install MySQL Server
- Remember your root password (or leave it empty as configured)

**Create the Database:**
1. Open MySQL Command Line Client or MySQL Workbench
2. Run this command to create the database:
```sql
CREATE DATABASE `timesheet-devops-db`;
```

**Or use MySQL Workbench:**
- Connect to MySQL server (localhost:3306)
- Create a new schema named `timesheet-devops-db`

### 2. Configure Database Connection (if needed)

The application is configured with:
- **Host**: localhost:3306
- **Database**: timesheet-devops-db
- **Username**: root
- **Password**: (empty - if you have a password, update `application.properties`)

If your MySQL root password is not empty, edit:
`src/main/resources/application.properties`
```properties
spring.datasource.password=YOUR_PASSWORD
```

### 3. Build and Run the Application

**Option A: Using Maven Wrapper (Recommended)**
```bash
# Windows
.\mvnw.cmd clean install
.\mvnw.cmd spring-boot:run

# Or if mvnw doesn't work, use:
mvn clean install
mvn spring-boot:run
```

**Option B: Using IDE (IntelliJ IDEA / Eclipse)**
1. Import the project as a Maven project
2. Find `TimesheetDevopsApplication.java`
3. Right-click → Run

**Option C: Run the JAR file**
```bash
mvn clean package
java -jar target/timesheet-devops-1.0.jar
```

### 4. Verify the Application is Running

Once started, you should see:
```
Started TimesheetDevopsApplication in X.XXX seconds
```

The application will be available at:
- **Base URL**: http://localhost:8082/timesheet-devops

### 5. Access the Application

**Test the API endpoints:**

1. **Get all users:**
   ```
   http://localhost:8082/timesheet-devops/user/retrieve-all-users
   ```

2. **Get user by ID:**
   ```
   http://localhost:8082/timesheet-devops/user/retrieve-user/1
   ```

**Ways to test:**
- **Browser**: Open the GET endpoints in your browser
- **Postman**: Import and test all endpoints
- **cURL**: Use command line
  ```bash
  curl http://localhost:8082/timesheet-devops/user/retrieve-all-users
  ```
- **PowerShell**:
  ```powershell
  Invoke-WebRequest -Uri http://localhost:8082/timesheet-devops/user/retrieve-all-users
  ```

### 6. Available REST Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/user/retrieve-all-users` | Get all users |
| GET | `/user/retrieve-user/{user-id}` | Get user by ID |
| POST | `/user/add-user` | Add new user |
| PUT | `/user/modify-user` | Update user |
| DELETE | `/user/remove-user/{user-id}` | Delete user |

**Full URL format:**
```
http://localhost:8082/timesheet-devops/user/{endpoint}
```

### Troubleshooting

**Problem: Port 8082 already in use**
- Change port in `application.properties`: `server.port=8083`

**Problem: Cannot connect to database**
- Make sure MySQL is running
- Check MySQL service: `services.msc` → MySQL
- Verify database exists: `SHOW DATABASES;`
- Check username/password in `application.properties`

**Problem: Application won't start**
- Check Java version compatibility
- Clean and rebuild: `mvn clean install`
- Check logs in: `C:/logs/timesheet-devops.log`

**Problem: 404 Not Found**
- Make sure you include the context path: `/timesheet-devops`
- Check the full URL format above

### Next Steps

Once running, you can:
1. Test the API endpoints using Postman or browser
2. Add users via POST request
3. View users via GET requests
4. Modify the code and see changes (with devtools enabled)

