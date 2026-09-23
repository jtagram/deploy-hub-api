#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "validar-tag-imagen: se esperaba exactamente un argumento (la etiqueta de la imagen)" >&2
  exit 1
fi

IMAGE_TAG="${1:-master}"

if [ -z "$IMAGE_TAG" ]; then
  IMAGE_TAG="master"
fi

case "$IMAGE_TAG" in
  ''|*[!a-zA-Z0-9._-]*)
    echo "validar-tag-imagen: la etiqueta de la imagen contiene caracteres no soportados" >&2
    exit 1
    ;;
esac

echo "El tag de la imagen ingresada es: $IMAGE_TAG"
