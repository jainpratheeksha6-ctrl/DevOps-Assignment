# Frontend Environment Configuration

## Environment Files

### `.env.local`
- **Purpose:** Local development
- **Backend URL:** http://localhost:8000
- **Usage:** `npm run dev`

### `.env.aws`
- **Purpose:** AWS deployment
- **Backend URL:** http://65.1.121.206:8000
- **Usage:** Build Docker image for AWS ECR

### `.env.azure`
- **Purpose:** Azure deployment
- **Backend URL:** https://devopsapp-dev-app.azurewebsites.net
- **Usage:** Build Docker image for Azure ACR

## Building for Different Clouds

### For AWS:
```bash
docker build -t frontend-app:aws \
  --build-arg NEXT_PUBLIC_API_URL=http://65.1.121.206:8000 \
  .
```

### For Azure:
```bash
docker build -t frontend-app:azure \
  --build-arg NEXT_PUBLIC_API_URL=https://devopsapp-dev-app.azurewebsites.net \
  .
```

## Why Separate Env Files?

- ✅ Different backend URLs per cloud
- ✅ Clear separation of concerns
- ✅ Easy to manage multiple environments
- ✅ Professional DevOps practice
- ✅ Demonstrates multi-cloud thinking
