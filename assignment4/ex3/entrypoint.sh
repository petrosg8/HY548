#!/bin/sh
exec python - <<'PY'
import os, controller
from controller import app
app.run(host="0.0.0.0", port=8000,
        ssl_context=("/tls/tls.crt", "/tls/tls.key"))
PY
