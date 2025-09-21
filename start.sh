#!/bin/bash

# Railway deployment startup script
set -e

# Set default port if not provided
export PORT=${PORT:-8000}

# Set default host
export HOST=${HOST:-0.0.0.0}

# Initialize database if needed
echo "Initializing database..."
python -c "from src.config.database import init_database; init_database()" || echo "Database initialization skipped or failed"

# Start the application
echo "Starting DeerFlow API server on $HOST:$PORT"
exec uvicorn src.server.app:app --host $HOST --port $PORT