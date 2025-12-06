# PostgreSQL Setup Guide for NestJS Backend API

## Option 1: Install PostgreSQL Locally (Windows)

### Step 1: Download and Install PostgreSQL
1. Go to https://www.postgresql.org/download/windows/
2. Download PostgreSQL 15 or latest version
3. Run the installer and follow these steps:
   - Accept license
   - Choose installation directory
   - Select components (keep defaults)
   - Choose data directory
   - Set password for `postgres` user (remember this!)
   - Port: 5432 (default)
   - Locale: [Your preference]
   - Click Install

### Step 2: Verify Installation
Open PowerShell and run:
```powershell
psql --version
```

### Step 3: Create Database and User
```powershell
psql -U postgres -h localhost
```

In the PostgreSQL prompt:
```sql
-- Create database
CREATE DATABASE nestjs_api;

-- Create user (optional)
CREATE USER nestjs_user WITH PASSWORD 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE nestjs_api TO nestjs_user;

-- Exit
\q
```

### Step 4: Update .env File
Edit `.env` with your PostgreSQL credentials:
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_postgres_password_set_during_install
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
```

---

## Option 2: Use Docker (Recommended)

### Prerequisites
- Install Docker Desktop from https://www.docker.com/products/docker-desktop

### Step 1: Run PostgreSQL in Docker
```powershell
docker run --name nestjs-postgres `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=postgres_password_123 `
  -e POSTGRES_DB=nestjs_api `
  -p 5432:5432 `
  -d postgres:15-alpine
```

### Step 2: Verify Container is Running
```powershell
docker ps
```

You should see `nestjs-postgres` running.

### Step 3: Update .env File
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres_password_123
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
```

### Step 4: Stop PostgreSQL (when done)
```powershell
docker stop nestjs-postgres
```

### Step 5: Start PostgreSQL (next time)
```powershell
docker start nestjs-postgres
```

---

## Option 3: Use PostgreSQL Online Service

### Use Neon (Free tier available)
1. Go to https://neon.tech
2. Sign up with GitHub/Google
3. Create a project
4. Copy connection string
5. Update `.env`:
```
DB_HOST=your-project.neon.tech
DB_PORT=5432
DB_USERNAME=your_username
DB_PASSWORD=your_generated_password
DB_NAME=neon_db
DB_SYNC=true
DB_LOGGING=false
```

---

## Step 5: Test the Connection

### Run the NestJS Application
```powershell
npm start
```

### Expected Output
```
[Nest] 12345  - 05/12/2025, 10:22:52 am     LOG [NestFactory] Starting Nest application...
[Nest] 12345  - 05/12/2025, 10:22:52 am     LOG [InstanceLoader] AppModule dependencies initialized
[Nest] 12345  - 05/12/2025, 10:22:52 am     LOG [TypeOrmModule] Initialized database connection
[Nest] 12345  - 05/12/2025, 10:22:53 am     LOG [NestApplication] Nest application successfully started +1234ms
Application is running on: http://localhost:3000
```

### Test API Endpoints
```powershell
# Create a user
curl -X POST http://localhost:3000/users `
  -H "Content-Type: application/json" `
  -d '{
    "email": "test@example.com",
    "fullName": "Test User",
    "password": "Password123",
    "phoneNumber": "+1234567890"
  }'

# Get all users (admin only)
curl -X GET http://localhost:3000/users `
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## Troubleshooting

### Error: "Unable to connect to the database"
1. Check if PostgreSQL is running
2. Verify `.env` credentials match your database setup
3. Check firewall isn't blocking port 5432

### Error: "database nestjs_api does not exist"
Create the database:
```powershell
psql -U postgres -c "CREATE DATABASE nestjs_api;"
```

### Error: "port 5432 already in use"
Change port in `.env` or kill the process using it:
```powershell
netstat -ano | findstr :5432
taskkill /PID <PID> /F
```

### Tables not created
Ensure `DB_SYNC=true` in `.env` - this will auto-create tables from entities.

---

## Next Steps

1. ✅ Choose setup option (Local, Docker, or Online)
2. ✅ Update `.env` file with credentials
3. ✅ Run `npm start`
4. ✅ Test API endpoints
5. ✅ Use Postman or Thunder Client for testing
