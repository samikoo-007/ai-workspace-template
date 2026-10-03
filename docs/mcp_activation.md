# MCP activation (optional)

1. `cp mcp_config.example.json mcp_config.json`
2. Put tokens in `.env` only
3. Set `"disabled": false` for servers you need
4. Restart the IDE / agent host so it reloads MCP

Never commit `mcp_config.json` if it can reference real secrets.
