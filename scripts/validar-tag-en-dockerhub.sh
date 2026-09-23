#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "validar-tag-en-dockerhub: se esperaban exactamente 3 argumentos (usuario, nombre del repositorio y etiqueta)" >&2
  exit 1
fi

DOCKERHUB_USERNAME="$1"
REPO_NAME="$2"
IMAGE_TAG="$3"

if [ -z "$IMAGE_TAG" ]; then
  IMAGE_TAG="master"
fi

bash "$(dirname "$0")/validar-tag-imagen.sh" "$IMAGE_TAG" >/dev/null

URL="https://hub.docker.com/v2/repositories/${DOCKERHUB_USERNAME}/${REPO_NAME}/tags/${IMAGE_TAG}"

if ! curl -fsSL --max-time 30 "$URL" >/dev/null 2>&1; then
  echo "validar-tag-en-dockerhub: la imagen ${DOCKERHUB_USERNAME}/${REPO_NAME}:${IMAGE_TAG} no existe en Docker Hub. Si es la primera publicación del proyecto, crea la imagen manualmente antes de ejecutar el deploy." >&2
  exit 1
fi

echo "validar-tag-en-dockerhub: la imagen ${DOCKERHUB_USERNAME}/${REPO_NAME}:${IMAGE_TAG} existe en Docker Hub."
