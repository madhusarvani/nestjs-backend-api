# Render.com Deployment - Step-by-Step Visual Guide

## 🚀 COMPLETE SETUP (Follow exactly)

### STEP 1: Sign Up on Render
```
1. Open: https://render.com
2. Click "Sign Up" (top right)
3. Choose "Sign up with GitHub"
4. Authorize Render to access GitHub
5. You're logged in ✅
```

---

### STEP 2: Create Web Service
```
Dashboard Home Page:

                    [+ New]  [Dashboard]
                    
1. Click [+ New] button (top right)
2. Select "Web Service"
```

---

### STEP 3: Connect Your Repository
```
Web Service Creation Form:

Choose repository to deploy:
┌─────────────────────────────────┐
│ GitHub Account: madhusarvani    │
│ Repo: [Select Repository]       │
│ • Other                         │
│ • nestjs-backend-api ← CLICK    │
│ • Student-Management-System     │
└─────────────────────────────────┘

1. Click "Connect account" if needed
2. Paste or select: nestjs-backend-api
3. Click "Connect"
```

---

### STEP 4: Configure Web Service Settings
```
Service Configuration Form:

Name:                   nestjs-backend-api
Environment:            Node
Region:                 Oregon (or nearest)
Branch:                 master
Build Command:          npm install && npm run build
Start Command:          node dist/src/main.js
Plan:                   Free

→ Scroll down and click [Create Web Service]
```

**Wait ~3-5 minutes for deployment to start...**

---

### STEP 5: Add PostgreSQL Database
```
After Web Service is created:

Dashboard Left Sidebar:
┌──────────────────┐
│ Services         │
│ ├─ nestjs-...    │
│ └─ + New    ← CLICK HERE
│
Dashboard Top:
[+ New] button also works
```

When you click "+ New":
```
Choose Service Type:
┌──────────────────┐
│ ✓ Web Service    │
│ → PostgreSQL     │ ← SELECT THIS
│ • Redis          │
│ • MySQL          │
│ • MongoDB        │
└──────────────────┘

Click PostgreSQL
```

Fill in PostgreSQL Settings:
```
Name:               nestjs-api-db
Database:           nestjs_api
Username:           postgres
(Password auto-generated)
Plan:               Free

→ Click [Create Database]
```

**Wait 1-2 minutes for database to initialize...**

---

### STEP 6: Link Database to Web Service
```
After PostgreSQL is created:

Render AUTOMATICALLY provides DATABASE_URL
environment variable to your web service.

You can verify:
1. Click your web service (nestjs-backend-api)
2. Go to "Environment" tab
3. Look for: DATABASE_URL=postgres://...
```

---

### STEP 7: Set Additional Environment Variables
```
In Web Service Environment Tab:

Add these variables:

Name: NODE_ENV
Value: production

Name: JWT_SECRET
Value: your-secure-secret-key-change-this-important

Name: PORT
Value: ${{ PORT }}

Click [Save Changes]
```

---

### STEP 8: Your App is Live! ✅
```
After all services are deployed:

Your API URL: https://nestjs-backend-api.onrender.com

Test it:
curl https://nestjs-backend-api.onrender.com/health

You should see:
{
  "status": "OK",
  "timestamp": "2025-12-06T..."
}
```

---

## 🔍 Troubleshooting

### "PostgreSQL not visible"
→ **Solution:** Use environment variable approach instead:
   - Add `DATABASE_URL` manually in web service environment
   - Use format: `postgresql://user:password@host:5432/dbname`

### "Build is failing"
→ Check in Render dashboard → Your Service → Logs tab

### "Application not starting"
→ Check environment variables are set correctly
→ Ensure `NODE_ENV=production` is not blocking

---

## ✅ Checklist

- [ ] GitHub repo connected to Render
- [ ] Web service deployed (has a live URL)
- [ ] PostgreSQL database created
- [ ] DATABASE_URL in environment variables
- [ ] NODE_ENV=production set
- [ ] JWT_SECRET set
- [ ] API health check returns 200 OK

---

## 📱 Test Your Live API

Once deployed, test these endpoints:

**Health Check:**
```bash
curl https://nestjs-backend-api.onrender.com/health
```

**Get All Products:**
```bash
curl https://nestjs-backend-api.onrender.com/products
```

**Register User:**
```bash
curl -X POST https://nestjs-backend-api.onrender.com/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "fullName": "Test User",
    "password": "TestPass123",
    "phoneNumber": "+1-555-0000"
  }'
```

---

## 🎉 You're Done!

Your NestJS API is now live on Render.com and automatically:
- Deploys on GitHub push
- Restarts if crashes
- Auto-scales (on paid plans)
- Maintains PostgreSQL backups

**Share your live URL with Code Inbound LLP HR team!**
