# openclaw-bot-JEFF

## 本地调试运行（非 Docker）

1. 安装 Node.js 22（或更高版本）。
2. 全局安装 OpenClaw CLI：

   ```bash
   npm install -g openclaw@latest
   ```

3. 准备配置文件（默认使用仓库内的 `config.json`）：

   ```bash
   mkdir -p ~/.openclaw
   cp config.json ~/.openclaw/openclaw.json
   ```

4. 设置必要的环境变量（以下示例以 Token 鉴权 + Anthropic 为例）：

   ```bash
   export ANTHROPIC_API_KEY="替换为你的anthropic key"
   export OPENCLAW_GATEWAY_TOKEN="替换为你的token"
   ```

5. 如果不想使用环境变量，也可以直接在 `~/.openclaw/openclaw.json` 中把 `OPENCLAW_GATEWAY_TOKEN` 的占位符替换成固定值。

6. 启动网关（默认端口 10000）：

   ```bash
   openclaw gateway --port 10000 --verbose
   ```

> 如果你使用 `openclaw-config.json`（已开启 WhatsApp 通道），可以改为：
>
> ```bash
> cp openclaw-config.json ~/.openclaw/openclaw.json
> ```

## Docker 调试运行

```bash
docker build -t openclaw-bot-jeff .
docker run --rm -p 10000:10000 \
  -e ANTHROPIC_API_KEY="替换为你的anthropic key" \
  -e OPENCLAW_GATEWAY_TOKEN="替换为你的token" \
  openclaw-bot-jeff
```

> 如果未设置 `OPENCLAW_GATEWAY_TOKEN`，容器会自动生成并打印到日志中（下次启动可手动固定该值）。

## 常见问题

### 1) 启动后无法访问或提示鉴权失败

确保客户端请求带上 `OPENCLAW_GATEWAY_TOKEN`，并与服务端一致。配置文件默认使用 Token 鉴权（见 `config.json`）。如果未设置 `OPENCLAW_GATEWAY_TOKEN`，请手动设置或直接把 `config.json` 中的占位符替换为固定值。

### 2) 端口冲突

将启动命令中的 `--port` 和容器映射端口改为未占用的端口。

### 3) 启动后模型调用失败

默认模型是 Anthropic（见 `config.json`），需要设置 `ANTHROPIC_API_KEY`。如果你使用其他模型或网关，请同步修改配置和环境变量。
