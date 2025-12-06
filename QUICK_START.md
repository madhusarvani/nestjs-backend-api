# NestJS Backend API - Quick Start Guide

## Prerequisites
- PostgreSQL 15 installed and running
- Node.js v18+ installed
- Environment variables configured in `.env` file

## Setup (One-time)

### 1. Install dependencies
```bash
npm install
```

### 2. Build the project
```bash
npm run build
```

### 3. Start PostgreSQL and create database
Run the setup script:
```powershell
.\setup_db_and_env.ps1
```

## Running the API

### Option 1: Direct Node (Production)
```bash
node dist/main.js
```

### Option 2: Using npm
```bash
npm start
```

### Option 3: Development mode with auto-reload
```bash
npm run start:dev
```

### Option 4: Using batch file
```bash
.\start-dev.bat
```

## Accessing the API

The API will be available at: **http://localhost:3000**

### Available Endpoints

#### Users
- `POST /users` - Register a new user
- `GET /users` - Get all users (requires JWT + admin)
- `GET /users/:id` - Get user by ID (requires JWT)
- `PATCH /users/:id` - Update user (requires JWT)
- `DELETE /users/:id` - Delete user (requires JWT + admin)

#### Authentication
- `POST /auth/login` - Login and get JWT token
- `GET /auth/profile` - Get current user profile (requires JWT)

#### Products
- `POST /products` - Create a product (requires JWT)
- `GET /products` - Get all products
- `GET /products/my-products` - Get current user's products (requires JWT)
- `GET /products/:id` - Get product by ID
- `PATCH /products/:id` - Update product (requires JWT)
- `DELETE /products/:id` - Delete product (requires JWT)

## Testing the API

### Using PowerShell Script
```powershell
# Run comprehensive tests
.\run-api-tests.ps1
```

### Using curl (Windows)
```bash
# Create a user
curl -X POST http://localhost:3000/users `
  -H "Content-Type: application/json" `
  -d "{\"email\":\"test@example.com\",\"fullName\":\"Test User\",\"password\":\"TestPass1\",\"phoneNumber\":\"+1-555-1234\"}"

# Get all products
curl http://localhost:3000/products
```

### Using Postman
1. Import the endpoints listed above
2. Use `Bearer <token>` in Authorization header for protected endpoints
3. Login first to get a token from `/auth/login`

## Environment Variables

The `.env` file should contain:
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
APP_PORT=3000
JWT_SECRET=your_secret_key
JWT_EXPIRATION=3600
```

## Database

Database is auto-created with TypeORM synchronization enabled. The following tables will be created:
- `user` - User accounts
- `product` - Product listings

## Troubleshooting

### Port 3000 already in use
Kill the process on port 3000:
```powershell
netstat -ano | findstr ":3000"
taskkill /PID <PID> /F
```

### Database connection error
1. Ensure PostgreSQL is running
2. Verify credentials in `.env`
3. Check if database `nestjs_api` exists
4. Run: `npm rebuild`

### Build errors
```bash
npm install
npm run build
```

## Project Structure

```
src/
├── app.module.ts           # Root module
├── main.ts                 # Entry point
├── config/
│   └── database.config.ts  # Database configuration
├── auth/                   # Authentication module
├── users/                  # Users module
└── products/               # Products module
```

## Notes

- All passwords are hashed using bcrypt with 10 rounds
- JWT tokens expire after 3600 seconds (1 hour)
- Validation is enabled for all DTOs
- CORS is enabled for localhost:3000
