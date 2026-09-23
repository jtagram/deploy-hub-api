#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "guardar-kubeconfig: se esperaban exactamente 2 argumentos (contenido del kubeconfig y ruta destino)" >&2
  exit 1
fi

KUBECONFIG_CONTENT="$1"
DESTINO="$2"

if [ -z "$KUBECONFIG_CONTENT" ]; then
  echo "guardar-kubeconfig: el contenido del kubeconfig está vacío" >&2
  exit 1
fi

umask 077
printf '%s\n' "$KUBECONFIG_CONTENT" > "$DESTINO"

echo "$DESTINO"
