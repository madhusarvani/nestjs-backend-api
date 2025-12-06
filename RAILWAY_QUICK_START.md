# Railway.app Deployment - Step by Step

## 🚀 Deploy in 5 Minutes

### STEP 1: Create Railway Account
```
1. Go to: https://railway.app
2. Click "Create Account"
3. Sign up with GitHub
4. Authorize Railway to access your GitHub
```

---

### STEP 2: Create New Project
```
From Railway Dashboard:

1. Click "New Project" button (top right)
2. Select "GitHub Repo"
3. Authorize Railway to access your GitHub
4. Find your repo: madhusarvani/nestjs-backend-api
5. Click "Connect"
```

Railway will auto-detect your Node.js project!

---

### STEP 3: Add PostgreSQL Database
```
In your Railway project:

1. Click "Add" button (or + Add Service)
2. Select "PostgreSQL"
3. Click "Add"

Railway auto-configures PostgreSQL! ✅
```

---

### STEP 4: Configure Environment Variables
```
For your Web Service:

1. Click the Web Service in your project
2. Go to "Variables" tab
3. Railway auto-provides from PostgreSQL:
   - DATABASE_URL (already set!)

4. Add these manually:
   - NODE_ENV = production
   - JWT_SECRET = your-secret-key-change-this
   - PORT = ${{ PORT }}

5. Click Save
```

---

### STEP 5: Deploy
```
1. Railway auto-deploys from GitHub
2. Go to "Deployments" tab
3. Wait for "Success" ✅
4. You get a live URL: https://your-app.railway.app
```

---

## ✅ What Railway Auto-Does

✅ Detects Node.js project  
✅ Installs dependencies  
✅ Runs: `npm install && npm run build`  
✅ Starts: `node dist/src/main.js`  
✅ Creates PostgreSQL database  
✅ Links database to app  
✅ Sets DATABASE_URL automatically  
✅ Auto-deploys on GitHub push  

---

## 🎯 Quick Checklist

- [ ] Create Railway account (GitHub login)
- [ ] Click "New Project"
- [ ] Connect GitHub repo
- [ ] Add PostgreSQL
- [ ] Set environment variables
- [ ] Wait for deployment
- [ ] Test live URL

---

## 📝 Environment Variables to Add

```
NODE_ENV=production
JWT_SECRET=your-super-secret-key-do-not-share
PORT=${{ PORT }}
```

**Railway provides DATABASE_URL automatically!** ✅

---

## ✅ After Deployment

Your live URL will be: `https://nestjs-backend-api.railway.app`

Test it:
```bash
curl https://nestjs-backend-api.railway.app/health
```

You should see:
```json
{
  "status": "OK",
  "timestamp": "2025-12-06T..."
}
```

---

## 🔗 Go to Railway Now

**https://railway.app**

1. Sign up with GitHub
2. New Project
3. Connect repo
4. Add PostgreSQL
5. Done! 🎉

---

**Your code is already on GitHub and ready to deploy!** ✅
