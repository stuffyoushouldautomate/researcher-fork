# Railway Environment Variables Setup

## Backend Service (Bulldozer-Backend)

Set these environment variables in your Railway dashboard for the backend service:

### Required Variables
```
AGENT_RECURSION_LIMIT=30
ALLOWED_ORIGINS=https://bulldozer825.com,https://bulldozerai.up.railway.app
BASIC_MODEL__api_key=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
BASIC_MODEL__max_retries=3
BASIC_MODEL__model=gpt-4o
BASIC_MODEL__platform=openai
BRAVE_SEARCH_API_KEY=BSA0RYWejvJiCzynjg82gwttUX48lMI
DEBUG=False
ENABLE_MCP_SERVER_CONFIGURATION=false
ENABLE_PYTHON_REPL=true
GITHUB_OAUTH_TOKEN=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
JINA_API_KEY=jina_7f6a6be9c6cb4edc87d30421a55219d94w751aHStEU-AcakhEVKcEmX8N6p
LANGGRAPH_CHECKPOINT_DB_URL=postgresql://postgres:NzSKXXskZABBHhdHJNAhSTjTaHDxAuaz@caboose.proxy.rlwy.net:12760/railway
LANGGRAPH_CHECKPOINT_SAVER=true
PORT=8000
SEARCH_API=tavily
SEARCH_ENGINE__engine=tavily
SEARCH_ENGINE__exclude_domains=unreliable-site.com,spam-domain.net
SEARCH_ENGINE__include_domains=trusted-news.com,gov.org,reliable-source.edu
TAVILY_API_KEY=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
```

### Database Variables (Auto-provided by Railway PostgreSQL)
```
PGDATA=/var/lib/postgresql/data/pgdata
PGDATABASE=railway
PGHOST=caboose.proxy.rlwy.net
PGPASSWORD=NzSKXXskZABBHhdHJNAhSTjTaHDxAuaz
PGPORT=12760
PGUSER=postgres
RESEARCH_DB_HOST=caboose.proxy.rlwy.net
RESEARCH_DB_NAME=railway
RESEARCH_DB_PASSWORD=NzSKXXskZABBHhdHJNAhSTjTaHDxAuaz
RESEARCH_DB_PORT=12760
RESEARCH_DB_USER=postgres
```

## Frontend Service (Bulldozer-Frontend)

Set these environment variables in your Railway dashboard for the frontend service:

### Required Variables
```
AGENT_RECURSION_LIMIT=30
ALLOWED_ORIGINS=*
APP_ENV=production
BASIC_MODEL__api_key=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
BASIC_MODEL__max_retries=3
BASIC_MODEL__model=gpt-4o
BASIC_MODEL__platform=openai
BRAVE_SEARCH_API_KEY=BSA0RYWejvJiCzynjg82gwttUX48lMI
DEBUG=False
ENABLE_MCP_SERVER_CONFIGURATION=false
ENABLE_PYTHON_REPL=true
GITHUB_OAUTH_TOKEN=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
JINA_API_KEY=jina_7f6a6be9c6cb4edc87d30421a55219d94w751aHStEU-AcakhEVKcEmX8N6p
LANGGRAPH_CHECKPOINT_DB_URL=postgresql://postgres:NzSKXXskZABBHhdHJNAhSTjTaHDxAuaz@caboose.proxy.rlwy.net:12760/railway
LANGGRAPH_CHECKPOINT_SAVER=true
NEXT_PUBLIC_API_URL=https://bulldozerai.up.railway.app/api
NEXT_PUBLIC_BRAND_COLOR=#ff6b35
NEXT_PUBLIC_BRAND_NAME=Bulldozer
NEXT_PUBLIC_LOGO_URL=/logo.png
PORT=8080
PUBLIC_URL=https://bulldozer825.com
RAILWAY_START_COMMAND=node .next/standalone/server.js
SEARCH_API=tavily
SEARCH_ENGINE__engine=tavily
SEARCH_ENGINE__exclude_domains=unreliable-site.com,spam-domain.net
SEARCH_ENGINE__include_domains=trusted-news.com,gov.org,reliable-source.edu
TAVILY_API_KEY=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
```

## How to Set Environment Variables

1. Go to your Railway dashboard
2. Select your project
3. Go to the "Variables" tab
4. Add each variable above for the respective service
5. Make sure to select the correct service (Backend or Frontend) when adding variables

## Important Notes

- The `PORT` variable is automatically set by Railway, but you can override it
- Database connection variables are automatically provided by Railway's PostgreSQL service
- Make sure the `NEXT_PUBLIC_API_URL` in the frontend points to your backend service URL
- The `ALLOWED_ORIGINS` should include your frontend domain for CORS to work properly
