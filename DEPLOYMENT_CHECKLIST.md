# Railway Deployment Checklist

## Pre-Deployment Checklist

- [ ] Railway CLI installed (`npm install -g @railway/cli`)
- [ ] Logged into Railway (`railway login`)
- [ ] PostgreSQL service added to project (`railway add postgresql`)
- [ ] Environment variables documented in `railway-env-setup.md`

## Deployment Steps

### 1. Deploy Backend Service
```bash
railway up --service Bulldozer-Backend
```

### 2. Set Backend Environment Variables
Use Railway dashboard or CLI to set all variables from `railway-env-setup.md` for the backend service.

**Critical Variables:**
- [ ] `BASIC_MODEL__api_key` - Your OpenAI API key
- [ ] `TAVILY_API_KEY` - Your Tavily search API key  
- [ ] `LANGGRAPH_CHECKPOINT_DB_URL` - Database connection string
- [ ] `ALLOWED_ORIGINS` - CORS origins

### 3. Deploy Frontend Service
```bash
railway up --service Bulldozer-Frontend --path web
```

### 4. Set Frontend Environment Variables
Set all variables from `railway-env-setup.md` for the frontend service.

**Critical Variables:**
- [ ] `NEXT_PUBLIC_API_URL` - Points to backend API URL
- [ ] `PUBLIC_URL` - Your frontend domain

### 5. Verify Deployment

#### Backend Health Check
```bash
curl https://bulldozerai.up.railway.app/health
```
Expected response: `{"status": "healthy", "service": "Bulldozer API", "version": "0.1.0"}`

#### Frontend Check
```bash
curl https://bulldozer825.com
```
Expected: HTML response from Next.js app

#### API Config Check
```bash
curl https://bulldozerai.up.railway.app/api/config
```
Expected: JSON with RAG and models configuration

## Post-Deployment Testing

### 1. Test Chat Functionality
- [ ] Open frontend in browser
- [ ] Try sending a message
- [ ] Verify response is generated
- [ ] Check browser console for errors

### 2. Test Research Features
- [ ] Try a research query
- [ ] Verify search functionality works
- [ ] Check if results are generated

### 3. Monitor Logs
```bash
# Backend logs
railway logs --service Bulldozer-Backend --follow

# Frontend logs
railway logs --service Bulldozer-Frontend --follow
```

## Common Issues & Quick Fixes

### Issue: Frontend can't connect to backend
**Fix:** Check `NEXT_PUBLIC_API_URL` in frontend environment variables

### Issue: CORS errors
**Fix:** Update `ALLOWED_ORIGINS` in backend to include frontend domain

### Issue: API key errors
**Fix:** Verify `BASIC_MODEL__api_key` and `TAVILY_API_KEY` are set correctly

### Issue: Database connection errors
**Fix:** Ensure PostgreSQL service is running and `DATABASE_URL` is set

## Files Modified for Railway Deployment

1. **railway.toml** - Updated service names and configuration
2. **Dockerfile** - Fixed port handling and health checks
3. **web/Dockerfile** - Fixed port handling for frontend
4. **server.py** - Fixed import path for uvicorn
5. **src/server/app.py** - Added health check endpoint
6. **.env** - Updated for production environment

## Support Files Created

1. **deploy-railway.sh** - Automated deployment script
2. **railway-env-setup.md** - Complete environment variables reference
3. **RAILWAY_TROUBLESHOOTING.md** - Comprehensive troubleshooting guide
4. **DEPLOYMENT_CHECKLIST.md** - This checklist

## Next Steps After Deployment

1. **Monitor Performance:** Check Railway dashboard for resource usage
2. **Set Up Monitoring:** Consider adding uptime monitoring
3. **Backup Database:** Set up regular database backups
4. **Update Documentation:** Document any custom configurations
5. **Test All Features:** Ensure all functionality works as expected

## Emergency Contacts

- Railway Support: https://railway.app/help
- Railway Status: https://status.railway.app
- Documentation: https://docs.railway.app
