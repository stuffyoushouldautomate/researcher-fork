# Railway Deployment Troubleshooting Guide

## Common Issues and Solutions

### 1. App Runs But Won't Generate Anything

**Symptoms:**
- Frontend loads but API calls fail
- Backend starts but returns errors
- No response from chat/research endpoints

**Causes & Solutions:**

#### A. Environment Variables Missing
```bash
# Check if all required variables are set
railway variables --service Bulldozer-Backend
railway variables --service Bulldozer-Frontend
```

**Required Backend Variables:**
- `BASIC_MODEL__api_key` - Your OpenAI API key
- `TAVILY_API_KEY` - Your Tavily search API key
- `LANGGRAPH_CHECKPOINT_DB_URL` - Database connection string

#### B. Database Connection Issues
```bash
# Check database connectivity
railway connect postgresql
```

**Fix:** Ensure PostgreSQL service is running and `DATABASE_URL` is set.

#### C. CORS Issues
**Frontend Error:** `Access to fetch at '...' from origin '...' has been blocked by CORS policy`

**Fix:** Update `ALLOWED_ORIGINS` in backend:
```
ALLOWED_ORIGINS=https://bulldozer825.com,https://bulldozerai.up.railway.app
```

#### D. API URL Mismatch
**Frontend Error:** `Failed to fetch config`

**Fix:** Ensure `NEXT_PUBLIC_API_URL` in frontend points to backend:
```
NEXT_PUBLIC_API_URL=https://bulldozerai.up.railway.app/api
```

### 2. Build Failures

#### A. Docker Build Issues
```bash
# Check build logs
railway logs --service Bulldozer-Backend --build
railway logs --service Bulldozer-Frontend --build
```

**Common Fixes:**
- Ensure all dependencies are in `requirements.txt` (backend)
- Check `package.json` dependencies (frontend)
- Verify Dockerfile syntax

#### B. Python Dependencies
```bash
# Test locally first
pip install -r requirements.txt
python -m src.server.app
```

#### C. Node.js Dependencies
```bash
# Test frontend locally
cd web
npm install
npm run build
```

### 3. Service Won't Start

#### A. Port Binding Issues
**Error:** `Address already in use`

**Fix:** Ensure services use Railway's `$PORT` variable:
- Backend: `PORT=8000`
- Frontend: `PORT=8080`

#### B. Missing Environment Variables
**Error:** `KeyError: 'BASIC_MODEL__api_key'`

**Fix:** Set all required environment variables in Railway dashboard.

### 4. Database Issues

#### A. Connection Refused
```bash
# Check if PostgreSQL service is running
railway status
```

**Fix:** Add PostgreSQL service:
```bash
railway add postgresql
```

#### B. Migration Issues
**Error:** `relation "..." does not exist`

**Fix:** Database tables are created automatically on first run.

### 5. API Key Issues

#### A. OpenAI API Key Invalid
**Error:** `Invalid API key`

**Fix:** 
1. Check API key format: `sk-proj-...`
2. Ensure key has sufficient credits
3. Verify key is set correctly in Railway

#### B. Tavily API Key Issues
**Error:** `Tavily API error`

**Fix:**
1. Get API key from https://tavily.com
2. Set `TAVILY_API_KEY` in Railway
3. Check API key format: `tvly-...`

## Debugging Commands

### Check Service Status
```bash
railway status
```

### View Logs
```bash
# Backend logs
railway logs --service Bulldozer-Backend

# Frontend logs  
railway logs --service Bulldozer-Frontend

# Real-time logs
railway logs --follow
```

### Test Endpoints
```bash
# Health check
curl https://bulldozerai.up.railway.app/health

# Config endpoint
curl https://bulldozerai.up.railway.app/api/config
```

### Environment Variables
```bash
# List all variables
railway variables

# Set a variable
railway variables set BASIC_MODEL__api_key=your_key_here --service Bulldozer-Backend
```

## Quick Fixes

### 1. Redeploy Services
```bash
# Redeploy backend
railway up --service Bulldozer-Backend

# Redeploy frontend
railway up --service Bulldozer-Frontend --path web
```

### 2. Restart Services
```bash
# Restart backend
railway restart --service Bulldozer-Backend

# Restart frontend
railway restart --service Bulldozer-Frontend
```

### 3. Check Service Health
```bash
# Backend health
curl https://bulldozerai.up.railway.app/health

# Frontend (should return HTML)
curl https://bulldozer825.com
```

## Still Having Issues?

1. **Check Railway Status Page:** https://status.railway.app
2. **Review Railway Documentation:** https://docs.railway.app
3. **Check Service Logs:** Look for specific error messages
4. **Test Locally:** Ensure app works in local environment first
5. **Verify Environment Variables:** Double-check all required variables are set

## Emergency Reset

If nothing works, try a complete reset:

```bash
# Delete and recreate services
railway service delete Bulldozer-Backend
railway service delete Bulldozer-Frontend

# Redeploy
railway up --service Bulldozer-Backend
railway up --service Bulldozer-Frontend --path web

# Set environment variables again
# (Use the railway-env-setup.md file as reference)
```
