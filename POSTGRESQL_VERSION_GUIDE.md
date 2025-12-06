# PostgreSQL Version Guide for NestJS Backend API

## ✅ Recommended Version: PostgreSQL 15 (Latest Stable)

**Download Link**: https://www.postgresql.org/download/windows/

### Why PostgreSQL 15?
- ✅ Latest stable version (released 2022)
- ✅ Best performance and security
- ✅ Full compatibility with NestJS & TypeORM
- ✅ Regular security updates
- ✅ Recommended for new projects

---

## 📊 Version Compatibility Chart

| Version | Release | Support | Recommendation | Download |
|---------|---------|---------|-----------------|----------|
| **15** | Oct 2022 | ✅ Active | **⭐ BEST** | https://www.postgresql.org/download/windows/ |
| 14 | Oct 2021 | ✅ Active | ✅ Good | https://www.postgresql.org/download/windows/ |
| 13 | Oct 2020 | ✅ Active | ✅ Good | https://www.postgresql.org/download/windows/ |
| 12 | Oct 2019 | ⚠️ Limited | Acceptable | https://www.postgresql.org/download/windows/ |
| 11 | Oct 2018 | ⚠️ Limited | ⚠️ Old | - |
| <11 | - | ❌ EOL | ❌ No | - |

---

## 🎯 Installation Steps for PostgreSQL 15

### Step 1: Download
1. Go to: https://www.postgresql.org/download/windows/
2. Click "Download the installer"
3. Choose **PostgreSQL 15.x** (latest in the 15 series)
4. Select your system:
   - 64-bit (recommended for most users)
   - 32-bit (only if your Windows is 32-bit)

### Step 2: Run Installer
1. Double-click the downloaded `.exe` file
2. Click "Next" to start

### Step 3: Installation Wizard

**Step 1 - Setup Wizard**
- Click "Next"

**Step 2 - Installation Directory**
- Default: `C:\Program Files\PostgreSQL\15`
- Click "Next" (accept default)

**Step 3 - Select Components**
- ✅ PostgreSQL Server
- ✅ pgAdmin 4
- ✅ Stack Builder
- ✅ Command Line Tools
- Click "Next"

**Step 4 - Data Directory**
- Default: `C:\Program Files\PostgreSQL\15\data`
- Click "Next"

**Step 5 - Password** ⚠️ **IMPORTANT!**
- Set a strong password for 'postgres' user
- Example: `MySecurePass123!`
- **SAVE THIS PASSWORD!** You'll need it for `.env` file
- Click "Next"

**Step 6 - Port Number**
- Default: `5432`
- Keep this default
- Click "Next"

**Step 7 - Locale**
- Choose your preference
- Click "Next"

**Step 8 - Ready to Install**
- Review settings
- Click "Next" to install

**Step 9 - Installation Complete**
- Click "Finish"

---

## ✔️ Verify Installation

Open PowerShell and run:

```powershell
psql --version
```

You should see:
```
psql (PostgreSQL) 15.X
```

---

## 📋 Quick Reference

### Your Installation Info After Setup:

```
Host:        localhost
Port:        5432
Database:    nestjs_api (we'll create this)
Username:    postgres
Password:    [What you set during installation]
Version:     PostgreSQL 15
```

### Update Your .env File:

After installation, edit `.env` in your project:

```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=[Your password from Step 5]
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
```

---

## 🚀 Next Steps

1. ✅ Download PostgreSQL 15 from: https://www.postgresql.org/download/windows/
2. ✅ Run installer with steps above
3. ✅ Remember your password!
4. ✅ Double-click `create-database.bat` (in project folder)
5. ✅ Double-click `start-app.bat` (in project folder)

---

## 💡 Why Not Older Versions?

| Reason | Impact |
|--------|--------|
| **Security** | Older versions have unpatched vulnerabilities |
| **Performance** | PostgreSQL 15 is 40% faster in some benchmarks |
| **Features** | Missing modern SQL features & JSON support |
| **Support** | Old versions get EOL (End of Life) soon |

**Recommendation**: Install **PostgreSQL 15** for best results! ✅

---

## 🔧 If You Already Have PostgreSQL Installed

If PostgreSQL is already on your system:

```powershell
# Check your current version
psql --version

# Connect to test it
psql -U postgres -h localhost
```

If you see **version 12 or higher**, you're good! No need to upgrade.

If you see **version 11 or lower**, consider upgrading to 15.

---

## 📞 Installation Issues?

### PostgreSQL not found after installation?
- Restart your computer
- Add to PATH: `C:\Program Files\PostgreSQL\15\bin`

### Installer won't run?
- Right-click installer → Run as Administrator

### Port 5432 already in use?
- PostgreSQL is already installed
- Just proceed with setup scripts

---

## ✨ You're Ready!

Download **PostgreSQL 15** and follow the installation steps above. 

**Questions about any step?** Feel free to ask! 🎉
