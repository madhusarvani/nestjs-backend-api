# Railway Deployment - Step by Step Guide

## Your GitHub Repository
```
https://github.com/madhusarvani/nestjs-backend-api
```

## Step 1: Create Railway Account
1. Go to https://railway.app
2. Click "Start Free" or "Sign Up"
3. Click "Continue with GitHub"
4. Authorize Railway to access your GitHub account

## Step 2: Create New Project
1. Click "New Project"
2. Select "GitHub Repo"
3. Search for: `nestjs-backend-api`
4. Click "Connect Repo"
5. Railway will auto-detect it's a Node.js project

## Step 3: Add PostgreSQL Database
1. Click "Add" button in the project
2. Select "PostgreSQL"
3. Click "Add"
4. Wait 2-3 minutes for database to initialize
5. Railway automatically sets `DATABASE_URL` environment variable ✅

## Step 4: Configure Environment Variables
In the web service settings, add these:

```
NODE_ENV=production
JWT_SECRET=your-secure-secret-key-change-this
PORT=${{ PORT }}
```

Note: `DATABASE_URL` is auto-set by PostgreSQL service ✅

## Step 5: Deploy
Railway auto-deploys when you:
- Push to GitHub (automatic)
- OR manually trigger from Railway dashboard

**Build Command**: `npm install && npm run build`
**Start Command**: `node dist/src/main.js`

## Step 6: Get Your Live URL
Once deployed (3-5 minutes):
1. Go to Railway project dashboard
2. Click on your web service
3. Look for "Domain" or "URL" section
4. You'll see something like:
   ```
   https://your-project-name.railway.app
   ```

## Step 7: Test Live API
```bash
curl https://your-project-name.railway.app/health
```

Response:
```json
{
  "status": "healthy",
  "uptime": 12345.67,
  "timestamp": "2025-12-06T10:35:05.818Z"
}
```

## Useful Links
- **Dashboard**: https://railway.app/dashboard
- **Your Project**: https://railway.app/project/[project-id]
- **GitHub Repo**: https://github.com/madhusarvani/nestjs-backend-api

## Troubleshooting
If you don't see a URL:
1. Check deployment status (Deployments tab)
2. Wait for "Success" status
3. Refresh the page
4. Check logs for any errors

## What You Get
✅ Live API URL  
✅ Auto-deployed from GitHub  
✅ PostgreSQL database included  
✅ SSL/HTTPS certificate  
✅ Free tier: $5 credit/month  

---

**Once deployed, share this URL with your assessor:**
```
https://your-project-name.railway.app
```

All 16 endpoints will be live at that URL!
