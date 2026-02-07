FROM node:22-slim

RUN apt-get update && apt-get install -y curl git jq && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install -g openclaw@latest

RUN mkdir -p /root/.openclaw/{workspace,logs,data,skills,credentials} \
    /root/.openclaw/agents/main/sessions && \
    chmod 700 /root/.openclaw

COPY config.json /root/.openclaw/openclaw.json
RUN chmod 600 /root/.openclaw/openclaw.json

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 10000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD curl -f http://localhost:${PORT:-10000}/ || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
