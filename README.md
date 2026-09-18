# tiingo-mcp (Coolify / Docker)

Streamable HTTP wrapper around [tiingo-mcp](https://github.com/major7apps/tiingo-mcp) for Claude.ai custom connectors.

Endpoint after deploy: `https://<your-domain>/mcp`

## Coolify

1. New resource → **Dockerfile** (or Docker Compose)
2. Port: `8000`
3. Domain: e.g. `mcp.example.com`
4. Env: `TIINGO_API_KEY`
5. Enable **Basic Auth** on the service (recommended)
6. Deploy

## Claude.ai

Settings → Connectors → Add custom connector

- URL: `https://mcp.example.com/mcp`
- Request header `Authorization`: `Basic <base64(user:password)>`

```bash
printf '%s' 'user:password' | base64
```

## Local

```bash
export TIINGO_API_KEY=your-key
docker compose up --build
curl -i http://127.0.0.1:8000/mcp
```
