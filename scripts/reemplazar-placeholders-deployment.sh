#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "reemplazar-placeholders-deployment: se esperaban exactamente 3 argumentos (usuario de Docker Hub, etiqueta de imagen y archivo)" >&2
  exit 1
fi

DOCKERHUB_USERNAME="$1"
IMAGE_TAG="$2"
ARCHIVO="$3"

if [ ! -f "$ARCHIVO" ]; then
  echo "reemplazar-placeholders-deployment: no se encontró el archivo $ARCHIVO" >&2
  exit 1
fi

sed -i \
  -e "s|DOCKERHUB_USER|$DOCKERHUB_USERNAME|g" \
  -e "s|IMAGE_TAG|$IMAGE_TAG|g" \
  "$ARCHIVO"
