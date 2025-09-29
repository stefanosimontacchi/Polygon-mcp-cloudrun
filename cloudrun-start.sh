#!/bin/sh
set -e

# ===== Config per Cloud Run / MCP HTTP =====
# Cloud Run passa la porta in $PORT. Impostiamo anche le variabili MCP_HTTP_*.
export MCP_TRANSPORT="${MCP_TRANSPORT:-streamable-http}"
export MCP_HTTP_HOST="0.0.0.0"
export MCP_HTTP_PORT="${PORT:-8080}"
export PYTHONUNBUFFERED=1

# Avviamo dal codice clonato durante la build (vedi Dockerfile)
cd /srv/mcp_polygon

# Avvio: preferisci uv; se non c'è, usa python
if command -v uv >/dev/null 2>&1; then
  exec uv run entrypoint.py
else
  exec python entrypoint.py
fi
