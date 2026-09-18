# tiingo-mcp (stdio) + Streamable HTTP gateway for Claude.ai / Coolify
FROM node:22-bookworm-slim

ARG TIINGO_MCP_VERSION=2.1.0
ARG TARGETARCH

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl xz-utils \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
  arch="${TARGETARCH:-amd64}"; \
  case "$arch" in \
    amd64|x86_64) rust_arch=x86_64 ;; \
    arm64|aarch64) rust_arch=aarch64 ;; \
    *) echo "unsupported arch: $arch" >&2; exit 1 ;; \
  esac; \
  curl -fsSL -o /tmp/tiingo-mcp.tar.xz \
    "https://github.com/major7apps/tiingo-mcp/releases/download/v${TIINGO_MCP_VERSION}/tiingo-mcp-${rust_arch}-unknown-linux-musl.tar.xz"; \
  mkdir -p /tmp/tiingo-mcp; \
  tar -xJf /tmp/tiingo-mcp.tar.xz -C /tmp/tiingo-mcp --strip-components=1; \
  install -m 0755 /tmp/tiingo-mcp/tiingo-mcp /usr/local/bin/tiingo-mcp; \
  rm -rf /tmp/tiingo-mcp /tmp/tiingo-mcp.tar.xz; \
  tiingo-mcp --version || true

RUN npm install -g supergateway@3

ENV PORT=8000 \
    NODE_ENV=production

EXPOSE 8000

# stdin from /dev/null keeps the HTTP gateway running in Docker
CMD ["sh", "-c", "exec supergateway --stdio tiingo-mcp --outputTransport streamableHttp --stateful --port \"${PORT:-8000}\" < /dev/null"]
