#!/bin/bash

# Railway Deployment Script for Bulldozer
# This script helps deploy both frontend and backend services to Railway

set -e

echo "🚀 Starting Railway deployment for Bulldozer..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI is not installed. Please install it first:"
    echo "   npm install -g @railway/cli"
    echo "   or visit: https://docs.railway.app/develop/cli"
    exit 1
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please log in to Railway first:"
    railway login
fi

echo "📋 Current Railway project info:"
railway status

# Deploy backend service
echo "🔧 Deploying backend service..."
railway up --service Bulldozer-Backend

# Wait a moment for backend to start
echo "⏳ Waiting for backend to initialize..."
sleep 10

# Deploy frontend service
echo "🎨 Deploying frontend service..."
railway up --service Bulldozer-Frontend --path web

echo "✅ Deployment complete!"
echo ""
echo "🌐 Your services should be available at:"
echo "   Backend: https://bulldozerai.up.railway.app"
echo "   Frontend: https://bulldozer825.com"
echo ""
echo "📊 Check deployment status with:"
echo "   railway status"
echo ""
echo "📝 View logs with:"
echo "   railway logs --service Bulldozer-Backend"
echo "   railway logs --service Bulldozer-Frontend"
