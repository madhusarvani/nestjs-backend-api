# 🐘 PostgreSQL Quick Commands

**All commands for managing your PostgreSQL database with NestJS API**

---

## ✅ Quick Setup

### Verify PostgreSQL is Running
```powershell
pg_isready -h localhost -p 5432
```
Should return: "accepting connections"

### Check Database Exists
```powershell
psql -U postgres -l | findstr "nestjs_api"
```

### Connect to Database
```powershell
psql -U postgres -d nestjs_api
```

---

## 📋 View Data

### List All Users
```sql
SELECT id, email, fullName, phoneNumber, isAdmin, createdAt FROM users;
```

### List All Products
```sql
SELECT id, name, price, quantity, status, userId, createdAt FROM products;
```

### Get User by Email
```sql
SELECT * FROM users WHERE email = 'user@example.com';
```

### Get Products for User
```sql
SELECT * FROM products WHERE "userId" = '[user-uuid]';
```

### Count Users and Products
```sql
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_products FROM products;
```

---

## 🔧 Manage Tables

### View Table Structure
```sql
\d users
\d products
```

### Check Indexes
```sql
SELECT * FROM pg_indexes WHERE schemaname = 'public';
```

### View Foreign Keys
```sql
SELECT constraint_name, table_name 
FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY';
```

---

## 🔐 User Management

### Create Admin User (Direct SQL)
```sql
INSERT INTO users (id, email, "fullName", password, "phoneNumber", "isAdmin", "createdAt", "updatedAt")
VALUES (
  gen_random_uuid(),
  'admin@example.com',
  'Admin User',
  '$2b$10$...',  -- bcrypt hashed password
  '555-0000',
  true,
  NOW(),
  NOW()
);
```

### Delete User and Their Products
```sql
DELETE FROM users WHERE email = 'user@example.com';
-- Products auto-delete (CASCADE enabled)
```

### Reset All Data
```sql
DELETE FROM products;
DELETE FROM users;
```

---

## 🗑️ Database Maintenance

### Drop and Recreate Database
```powershell
psql -U postgres -c "DROP DATABASE IF EXISTS nestjs_api;"
psql -U postgres -c "CREATE DATABASE nestjs_api;"
```

### Backup Database
```powershell
pg_dump -U postgres nestjs_api > nestjs_api_backup.sql
```

### Restore Database
```powershell
psql -U postgres nestjs_api < nestjs_api_backup.sql
```

### Check Database Size
```sql
SELECT pg_size_pretty(pg_database_size('nestjs_api'));
```

---

## 📊 Database Statistics

### Row Counts
```sql
SELECT 
  (SELECT COUNT(*) FROM users) as users,
  (SELECT COUNT(*) FROM products) as products;
```

### Table Sizes
```sql
SELECT 
  schemaname, tablename, 
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Recent Data
```sql
SELECT * FROM users ORDER BY "createdAt" DESC LIMIT 10;
SELECT * FROM products ORDER BY "createdAt" DESC LIMIT 10;
```

---

## 🔍 Monitoring

### Check Active Connections
```sql
SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;
```

### Kill a Connection
```sql
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'nestjs_api' AND pid <> pg_backend_pid();
```

### View Slow Queries (if logging enabled)
```sql
SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;
```

---

## 💡 Useful Queries

### Search Users
```sql
SELECT * FROM users WHERE email LIKE '%@example.com';
```

### Find Products Over Price
```sql
SELECT * FROM products WHERE price > 100 ORDER BY price DESC;
```

### User with Most Products
```sql
SELECT u.email, u."fullName", COUNT(p.id) as product_count
FROM users u
LEFT JOIN products p ON u.id = p."userId"
GROUP BY u.id
ORDER BY product_count DESC;
```

### Products by Status
```sql
SELECT status, COUNT(*) as count FROM products GROUP BY status;
```

---

## 🚀 From NestJS API

### Your API Automatically:
1. ✅ Creates users table on startup
2. ✅ Creates products table on startup
3. ✅ Maintains relationships and foreign keys
4. ✅ Handles password encryption
5. ✅ Syncs schema changes on restart

**No manual SQL needed for normal operations!**

---

## 📞 Common Issues

### "FATAL: Ident authentication failed"
- Use password authentication in `.env`
- Already configured ✅

### "Database does not exist"
```powershell
psql -U postgres -c "CREATE DATABASE nestjs_api;"
```

### "Connection refused"
```powershell
# Start PostgreSQL service
net start PostgreSQL-x64-15

# Or check status
pg_isready -h localhost
```

### "Column does not exist"
- Restart server to sync entities
- Check table definition: `\d users`

---

## 📚 More Help

- PostgreSQL Docs: https://www.postgresql.org/docs/
- psql Commands: `\?` in psql
- TypeORM Docs: https://typeorm.io/
- Your API: http://localhost:3000

---

**Your API handles all database operations automatically!**
These SQL commands are only needed for manual inspection or advanced operations.

✅ Ready to go! Start your server and the database will work automatically.
