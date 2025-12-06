# NestJS Backend API - Setup & Running Guide

## Prerequisites

Before you start, make sure you have:

- **Node.js** (v16 or higher) - Download from https://nodejs.org/
- **PostgreSQL** (v12 or higher) - Download from https://www.postgresql.org/download/windows/

---

## 🚀 Quick Start (Recommended)

### Step 1: Install PostgreSQL

1. Download PostgreSQL from: https://www.postgresql.org/download/windows/
2. Run the installer with these settings:
   - **Version**: PostgreSQL 15 (or latest)
   - **Password**: Set a strong password for `postgres` user (save this!)
   - **Port**: 5432 (default)
   - **Locale**: Your preference
3. Complete the installation

### Step 2: Setup Database Automatically

**Option A: Using Setup Script (Recommended)**
```powershell
# Navigate to project directory
cd "C:\path\to\nestjs-backend-api"

# Run setup script
.\setup-postgres.ps1
```

When prompted, enter the PostgreSQL `postgres` user password you set during installation.

**Option B: Using Batch File**
Double-click `setup-postgres.bat` in the project folder and follow the prompts.

### Step 3: Build & Run

**Option A: Using Batch File (Easiest)**
Double-click `start-app.bat` in the project folder.

**Option B: Using Terminal**
```powershell
# Build the project
npm run build

# Start the application
npm start
```

### Step 4: Verify It's Running

You should see:
```
[Nest] 12345 - 05/12/2025, 10:30:00 am LOG [NestFactory] Starting Nest application...
[Nest] 12345 - 05/12/2025, 10:30:01 am LOG [TypeOrmModule] Initialized database connection
[Nest] 12345 - 05/12/2025, 10:30:02 am LOG [NestApplication] Nest application successfully started
Application is running on: http://localhost:3000
```

---

## 📝 Manual Setup (If Scripts Don't Work)

### Create Database Manually

1. Open PowerShell
2. Connect to PostgreSQL:
```powershell
psql -U postgres -h localhost
```

3. When prompted, enter your PostgreSQL password

4. In the PostgreSQL prompt, run:
```sql
CREATE DATABASE nestjs_api;
\q
```

### Update .env File

1. Open the project folder
2. Find `.env` file
3. Update with your credentials:
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_postgres_password_here
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
```

---

## 🧪 Test the API

### Using PowerShell

**Create a User:**
```powershell
$body = @{
    email = "test@example.com"
    fullName = "Test User"
    password = "Password123"
    phoneNumber = "+1234567890"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/users" `
  -Method POST `
  -ContentType "application/json" `
  -Body $body
```

**Get All Users (Admin):**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/users" `
  -Method GET `
  -Headers @{Authorization = "Bearer YOUR_JWT_TOKEN"}
```

### Using VS Code REST Client Extension

1. Install "REST Client" extension in VS Code
2. Create `test.http` file:
```http
### Create User
POST http://localhost:3000/users
Content-Type: application/json

{
  "email": "test@example.com",
  "fullName": "Test User",
  "password": "Password123",
  "phoneNumber": "+1234567890"
}

### Get All Users
GET http://localhost:3000/users
Authorization: Bearer YOUR_JWT_TOKEN
```

3. Click "Send Request" above each endpoint

---

## 🛑 Troubleshooting

### PostgreSQL Not Recognized
```powershell
# Check if PostgreSQL is in PATH
psql --version

# If not found, add to PATH or specify full path
"C:\Program Files\PostgreSQL\15\bin\psql" -U postgres
```

### Database Already Exists
This is normal - the setup script handles this. You can safely re-run it.

### Port 5432 Already in Use
```powershell
# Find process using port 5432
netstat -ano | findstr :5432

# Kill the process (replace XXXX with PID)
taskkill /PID XXXX /F
```

### Connection Refused
1. Check PostgreSQL is running:
```powershell
Get-Service postgresql*
```

2. If not running, start it:
```powershell
Start-Service postgresql-x64-15
```

3. Verify .env credentials match your PostgreSQL setup

### Tables Not Created
Ensure `DB_SYNC=true` in `.env` - this auto-creates tables from entities.

---

## 📁 Project Structure

```
nestjs-backend-api/
├── src/
│   ├── auth/                 # Authentication module
│   ├── users/                # Users module
│   ├── products/             # Products module
│   ├── config/               # Database config
│   ├── app.module.ts         # Main app module
│   └── main.ts              # Entry point
├── dist/                     # Compiled JavaScript
├── .env                      # Environment variables (UPDATE THIS!)
├── .env.example              # Environment template
├── setup-postgres.ps1        # PostgreSQL setup script
├── setup-postgres.bat        # Batch file for setup
├── start-app.bat             # Quick start batch file
└── package.json              # Dependencies
```

---

## 🔑 Environment Variables

Update `.env` with your actual values:

```env
# Database
DB_HOST=localhost              # PostgreSQL host
DB_PORT=5432                  # PostgreSQL port
DB_USERNAME=postgres          # PostgreSQL user
DB_PASSWORD=your_password     # PostgreSQL password
DB_NAME=nestjs_api           # Database name
DB_SYNC=true                  # Auto-create tables
DB_LOGGING=false              # Log SQL queries

# JWT
JWT_SECRET=your_secret_key    # Change in production!
JWT_EXPIRATION=3600           # Token expiration (seconds)

# App
APP_PORT=3000                 # Application port
NODE_ENV=development          # Environment
```

---

## 📚 Available Scripts

```bash
# Build TypeScript
npm run build

# Start application
npm start

# Start with watch mode (auto-reload)
npm run start:dev

# Run tests
npm test

# Run tests with coverage
npm run test:cov
```

---

## 🌐 API Endpoints

### Users
- `POST /users` - Create user
- `GET /users` - Get all users (admin only)
- `GET /users/:id` - Get user by ID
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Delete user (admin only)

### Products
- `POST /products` - Create product
- `GET /products` - Get all products
- `GET /products/:id` - Get product by ID
- `PATCH /products/:id` - Update product
- `DELETE /products/:id` - Delete product

### Auth
- `POST /auth/login` - User login

---

## 💡 Tips

1. **Backup Your Database**: Regularly backup your PostgreSQL data
2. **Change JWT Secret**: Update `JWT_SECRET` in production
3. **Use Environment Files**: Never commit `.env` to git (it's ignored)
4. **Monitor Logs**: Watch terminal output for database connection issues
5. **Database Sync**: Set `DB_SYNC=false` after development to prevent accidental drops

---

## 📞 Need Help?

1. Check the troubleshooting section above
2. Review PostgreSQL logs: `C:\Program Files\PostgreSQL\15\data\log\`
3. Verify credentials in `.env` match your PostgreSQL setup
4. Ensure PostgreSQL service is running

---

**Happy coding! 🎉**
