#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "crear-copia-de-trabajo-de-manifiestos: se esperaban exactamente 2 argumentos (directorio origen y directorio destino)" >&2
  exit 1
fi

DIRECTORIO_ORIGEN="$1"
DIRECTORIO_DESTINO="$2"

if [ ! -d "$DIRECTORIO_ORIGEN" ]; then
  echo "crear-copia-de-trabajo-de-manifiestos: no se encontró el directorio origen $DIRECTORIO_ORIGEN" >&2
  exit 1
fi

mkdir -p "$DIRECTORIO_DESTINO"
cp "$DIRECTORIO_ORIGEN"/*.yaml "$DIRECTORIO_DESTINO/"

echo "$DIRECTORIO_DESTINO"
