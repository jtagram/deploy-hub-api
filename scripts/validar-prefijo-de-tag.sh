#!/usr/bin/env bash
set -u

if [ "$#" -ne 3 ]; then
  echo "validar-prefijo-de-tag: se esperaban exactamente tres argumentos (el nombre del tag, su valor y el prefijo requerido)" >&2
  exit 1
fi

TAG_NAME="$1"
TAG_VALUE="$2"
REQUIRED_PREFIX="$3"

if [ -z "$REQUIRED_PREFIX" ]; then
  echo "validar-prefijo-de-tag: el prefijo requerido para $TAG_NAME no está definido" >&2
  exit 1
fi

case "$TAG_VALUE" in
  "$REQUIRED_PREFIX"*) ;;
  *)
    echo "validar-prefijo-de-tag: el tag $TAG_NAME (\"$TAG_VALUE\") debe empezar con el prefijo \"$REQUIRED_PREFIX\" (ejemplo: ${REQUIRED_PREFIX}v0.1.1)" >&2
    exit 1
    ;;
esac

exit 0
