# 🎯 Quick Reference Card

Print this page or bookmark for quick access!

---

## ⚡ Start Server (30 seconds)

```powershell
npm run build
node dist/main.js
```

**Server**: http://localhost:3000 ✅

---

## 📋 All 16 Endpoints

```
GET     /                    → Health status
GET     /health              → Health check
POST    /users               → Create user
GET     /users               → List users (admin)
GET     /users/:id           → Get user
PATCH   /users/:id           → Update user
DELETE  /users/:id           → Delete user (admin)
POST    /auth/login          → Login
GET     /auth/profile        → Get profile (JWT)
POST    /products            → Create product (JWT)
GET     /products            → List products
GET     /products/my-products → User's products (JWT)
GET     /products/:id        → Get product
PATCH   /products/:id        → Update (JWT)
DELETE  /products/:id        → Delete (JWT)
```

---

## 🔑 Authentication

### 1. Create User
```json
POST /users
{
  "email": "user@example.com",
  "fullName": "John Doe",
  "password": "Pass123",
  "phoneNumber": "555-0000"
}
```

### 2. Login
```json
POST /auth/login
{
  "email": "user@example.com",
  "password": "Pass123"
}
```

Response: `{"access_token": "eyJ..."}`

### 3. Use Token
```
Authorization: Bearer eyJ...
```

---

## 📦 npm Commands

| Command | What it does |
|---------|-------------|
| `npm install` | Install dependencies |
| `npm run build` | Build TypeScript |
| `npm run start:dev` | Start with hot-reload |
| `npm test` | Run tests |
| `npm run lint` | Check code |
| `npm run format` | Format code |

---

## 🗂️ Key Files

| File | Purpose |
|------|---------|
| `.env` | Configuration (passwords, secrets) |
| `src/` | Source code |
| `dist/` | Compiled JavaScript |
| `package.json` | Dependencies |

---

## 📚 Documentation

- **FINAL_SUMMARY.md** ← Start here
- **QUICK_START.md** ← Fast commands
- **API_DOCUMENTATION.md** ← All endpoints
- **PROJECT_STATUS.md** ← Full details
- **DOCUMENTATION_INDEX.md** ← All guides

---

## 🔐 Default Config

- **Database**: nestjs_api (PostgreSQL)
- **Host**: localhost:5432
- **Port**: 3000
- **JWT Expiration**: 3600 seconds

---

## 🐛 Common Fixes

**Port already in use**
```powershell
netstat -ano | findstr :3000
taskkill /PID [PID] /F
```

**Database connection error**
- Verify PostgreSQL is running
- Check credentials in `.env`
- Recreate database: `create-database.bat`

**Build fails**
```powershell
npm install
npm run build
npm rebuild bcrypt
```

---

## ✅ Status

- ✅ Server compiles
- ✅ Database connected
- ✅ 16 endpoints mapped
- ✅ Authentication working
- ✅ Ready to use

---

## 🚀 Next Steps

1. Start: `node dist/main.js`
2. Test: `GET http://localhost:3000/health`
3. Create: `POST http://localhost:3000/users`
4. Login: `POST http://localhost:3000/auth/login`
5. Use: Add `Authorization: Bearer [token]` header

---

**Need help?** Open DOCUMENTATION_INDEX.md for all guides.

🎉 **Happy coding!**
