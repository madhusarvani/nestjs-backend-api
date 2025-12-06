# Railway.app Deployment Guide

## Quick Deploy to Railway (5 minutes)

### Step 1: Create Railway Account ✅

1. Go to **https://railway.app**
2. Click **"Login"** → **"Login with GitHub"**
3. Authorize Railway to access your GitHub account
4. You'll be redirected to the Railway dashboard

---

### Step 2: Create New Project ✅

1. Click **"New Project"** button
2. Select **"Deploy from GitHub repo"**
3. Search for and select: **`madhusarvani/nestjs-backend-api`**
4. Click **"Deploy Now"**

Railway will automatically:
- Detect your Node.js project
- Run `npm install && npm run build`
- Deploy your application

---

### Step 3: Add PostgreSQL Database ✅

1. In your Railway project dashboard
2. Click **"+ Add"** button (top right)
3. Click **"Database"** section
4. Select **"PostgreSQL"**
5. Railway will create a PostgreSQL instance and auto-connect it

---

### Step 4: Configure Environment Variables ✅

1. Click on your **web service** in the Railway dashboard
2. Go to **"Variables"** tab
3. Railway automatically provides these from PostgreSQL:
   - `DATABASE_URL` (Railway creates this automatically)

4. Add these manual variables:
   ```
   NODE_ENV = production
   JWT_SECRET = your-super-secret-key-change-this
   PORT = ${{ PORT }}
   ```

5. For database connection, Railway provides `DATABASE_URL` which contains:
   - DB_HOST
   - DB_PORT
   - DB_USERNAME
   - DB_PASSWORD
   - DB_NAME

**Important:** Update your `database.config.ts` to use `DATABASE_URL` or parse it.

---

### Step 5: Verify Deployment ✅

1. Railway will show you a live URL like: `https://your-app.railway.app`
2. Test your API:
   ```bash
   curl https://your-app.railway.app/health
   ```

3. You should see:
   ```json
   {
     "status": "OK",
     "timestamp": "2025-12-06T..."
   }
   ```

---

## Auto-Deployment Setup ✅

After initial deployment, Railway automatically:
- ✅ Watches your GitHub repository
- ✅ Deploys on every push to `master` branch
- ✅ Auto-rebuilds and restarts your app
- ✅ Maintains zero downtime deployments

---

## Environment Variables Summary

| Variable | Value | Source |
|----------|-------|--------|
| `NODE_ENV` | `production` | Manual |
| `JWT_SECRET` | Your secret key | Manual |
| `DATABASE_URL` | Auto-provided | PostgreSQL addon |
| `PORT` | Auto-assigned | Railway |

---

## Important: Update Database Config

Your app needs to handle `DATABASE_URL`. Update `src/config/database.config.ts`:

```typescript
export class DatabaseConfig implements TypeOrmModuleOptions {
  constructor(private configService: ConfigService) {}

  createTypeOrmOptions(): TypeOrmModuleOptions {
    const databaseUrl = this.configService.get<string>('DATABASE_URL');
    
    if (databaseUrl) {
      // Parse PostgreSQL connection string
      return {
        type: 'postgres',
        url: databaseUrl,
        synchronize: true,
        dropSchema: false,
        entities: [User, Product],
        logging: ['error'],
      };
    }

    // Fallback to individual env variables (local development)
    return {
      type: 'postgres',
      host: this.configService.get<string>('DB_HOST') || 'localhost',
      port: this.configService.get<number>('DB_PORT') || 5432,
      username: this.configService.get<string>('DB_USERNAME') || 'postgres',
      password: this.configService.get<string>('DB_PASSWORD') || '',
      database: this.configService.get<string>('DB_NAME') || 'nestjs_api',
      synchronize: true,
      dropSchema: false,
      entities: [User, Product],
      logging: ['error'],
    };
  }
}
```

---

## Monitoring & Logs

In Railway dashboard:
1. Click your **web service**
2. Go to **"Logs"** tab
3. Monitor real-time logs for errors/issues
4. Click **"Deploy"** to see deployment history

---

## Costs

| Component | Cost |
|-----------|------|
| Web Service | $5/month (included in Railway credits) |
| PostgreSQL | Free tier or $5+/month |
| **Total** | **~$5-10/month** |

Railway gives you $5 free credit monthly, so initial deployment may be free!

---

## Testing Your Live API

Once deployed, test with:

```bash
# Health check
curl https://your-app.railway.app/health

# Get root info
curl https://your-app.railway.app/

# List products (public)
curl https://your-app.railway.app/products

# Register user
curl -X POST https://your-app.railway.app/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "fullName": "Test User",
    "password": "TestPass123",
    "phoneNumber": "+1-555-0000"
  }'

# Login
curl -X POST https://your-app.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123"
  }'
```

---

## Troubleshooting

### "Build Failed" Error
- Check Railway Logs tab
- Ensure `npm run build` works locally
- Verify all dependencies are in `package.json`

### "Cannot connect to database"
- Check PostgreSQL addon is added to project
- Verify `DATABASE_URL` environment variable is set
- Check `database.config.ts` handles `DATABASE_URL`

### "Port already in use"
- Railway assigns PORT automatically via `${{ PORT }}`
- Ensure your app reads `process.env.PORT`

---

## Next Steps

1. ✅ Create Railway account
2. ✅ Deploy from GitHub
3. ✅ Add PostgreSQL database
4. ✅ Set environment variables
5. ✅ Test live API endpoints
6. ✅ Monitor logs and metrics

Your API will be live in minutes! 🚀

---

## Support

- Railway Docs: https://docs.railway.app
- NestJS Deployment: https://docs.nestjs.com/deployment
- Railway Support: https://railway.app/support
