# Railway Deployment Guide

This document provides instructions for deploying DeerFlow (Bulldozer) to Railway.

## Quick Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/deploy)

## Manual Deployment

### Prerequisites

1. A Railway account
2. A PostgreSQL database (Railway provides this)
3. Optional: MongoDB database for checkpointing

### Environment Variables

Railway will automatically provide these variables:
- `PORT` - Dynamic port assignment
- `RAILWAY_ENVIRONMENT` - Railway environment name
- `RAILWAY_PROJECT_ID` - Your project ID
- `DATABASE_URL` - PostgreSQL connection string
- `RAILWAY_PUBLIC_DOMAIN` - Your app's domain

You need to set these manually:
- `NEXT_PUBLIC_API_URL` - Backend API URL (usually `https://your-backend-domain/api`)
- `NEXT_PUBLIC_BRAND_NAME` - Your app name (default: "Bulldozer")
- `NEXT_PUBLIC_LOGO_URL` - Logo URL (default: "/logo.png")
- `NEXT_PUBLIC_BRAND_COLOR` - Brand color (default: "#ff6b35")

Optional:
- `GITHUB_OAUTH_TOKEN` - For GitHub integrations
- `MONGODB_URL` - For MongoDB checkpointing

### Services Configuration

This project is configured to deploy as two services:

1. **Backend Service**: Python FastAPI server
   - Uses `Dockerfile` in root directory
   - Runs on dynamic `$PORT`
   - Serves API endpoints

2. **Frontend Service**: Next.js web application
   - Uses `web/Dockerfile`
   - Runs on dynamic `$PORT`
   - Serves the web interface

### Deployment Steps

1. **Create Railway Project**
   ```bash
   railway login
   railway init
   ```

2. **Add PostgreSQL Database**
   ```bash
   railway add postgresql
   ```

3. **Deploy Services**
   ```bash
   # Deploy backend
   railway up --service backend

   # Deploy frontend
   railway up --service frontend --path web
   ```

4. **Configure Environment Variables**
   - Go to Railway dashboard
   - Set `NEXT_PUBLIC_API_URL` to your backend service URL + `/api`
   - Configure other optional variables as needed

### Configuration Files

- `railway.toml` - Railway service configuration
- `railway.json` - Build and deploy settings
- `Procfile` - Alternative process definition
- `start.sh` - Startup script
- `.env` - Environment variables template

### Health Checks

The backend includes health check endpoints:
- `/api/config` - Configuration status
- `/health` - Service health

### Troubleshooting

1. **Port Binding Issues**: Ensure services use `$PORT` environment variable
2. **Database Connection**: Check `DATABASE_URL` is properly set
3. **CORS Issues**: Verify `NEXT_PUBLIC_API_URL` matches backend domain
4. **Build Failures**: Check Docker build logs for missing dependencies

### File Structure

```
├── Dockerfile              # Backend container
├── railway.toml            # Railway configuration
├── railway.json           # Build settings
├── Procfile               # Process definition
├── start.sh               # Startup script
├── web/
│   ├── Dockerfile         # Frontend container
│   └── ...                # Frontend code
└── ...                    # Backend code
```

## Support

For deployment issues, check:
1. Railway deployment logs
2. Service health endpoints
3. Environment variable configuration
4. Database connectivity