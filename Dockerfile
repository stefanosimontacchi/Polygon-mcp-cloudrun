# Immagine base leggera con Python
FROM python:3.11-slim

# Non bufferizzare stdout/stderr (log visibili subito)
ENV PYTHONUNBUFFERED=1

# Lavoriamo in /srv
WORKDIR /srv

# Installiamo git (per clonare il repo) e uv (runner Python usato dal progetto)
RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && pip install --no-cache-dir uv

# Cloniamo il server MCP ufficiale di Polygon dentro l'immagine
RUN git clone https://github.com/polygon-io/mcp_polygon.git /srv/mcp_polygon

# Installiamo le dipendenze del progetto (modo supportato dal repo: uv pip install -e .)
WORKDIR /srv/mcp_polygon
RUN uv pip install --system -e .

# Torniamo alla cartella di lavoro
WORKDIR /srv

# Copiamo lo script di avvio e rendiamolo eseguibile
COPY cloudrun-start.sh /srv/cloudrun-start.sh
RUN chmod +x /srv/cloudrun-start.sh

# Avvio di default del container
CMD ["/srv/cloudrun-start.sh"]
