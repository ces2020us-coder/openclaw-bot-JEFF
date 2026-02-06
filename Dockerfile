FROM node:22-slim

RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install -g openclaw@latest

RUN mkdir -p /root/.openclaw

COPY config.json /root/.openclaw/openclaw.json

EXPOSE 10000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:10000/ || exit 1

CMD ["sh", "-c", "openclaw onboard --install-daemon || true && openclaw gateway --port ${PORT:-10000} --verbose"]
