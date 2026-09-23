#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "validar-yaml-manifiestos: se esperaba exactamente un argumento (ruta a un archivo .yaml)" >&2
  exit 1
fi

MANIFEST_PATH="$1"

if [ ! -f "$MANIFEST_PATH" ]; then
  echo "validar-yaml-manifiestos: no se encontró el archivo $MANIFEST_PATH" >&2
  exit 1
fi

if ! python3 -c "
import sys
import yaml

with open(sys.argv[1]) as f:
    documentos = [doc for doc in yaml.safe_load_all(f) if doc]

sys.exit(0 if documentos else 1)
" "$MANIFEST_PATH"; then
  echo "validar-yaml-manifiestos: $MANIFEST_PATH tiene sintaxis YAML inválida o está vacío" >&2
  exit 1
fi

echo "validar-yaml-manifiestos: $MANIFEST_PATH tiene sintaxis YAML válida"
