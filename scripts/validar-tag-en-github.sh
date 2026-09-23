#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "validar-tag-en-github: se esperaban exactamente 2 argumentos (repositorio owner/repo y etiqueta)" >&2
  exit 1
fi

REPOSITORIO="$1"
TAG="$2"

if [ -z "$TAG" ]; then
  echo "validar-tag-en-github: se esperaba una etiqueta no vacía" >&2
  exit 1
fi

HTTP_STATUS="$(curl -s -o /dev/null -w '%{http_code}' \
  "https://api.github.com/repos/$REPOSITORIO/git/ref/tags/$TAG")"

if [ "$HTTP_STATUS" = "404" ]; then
  echo "validar-tag-en-github: el tag '$TAG' no existe en el repositorio '$REPOSITORIO' de GitHub." >&2
  echo "validar-tag-en-github: si todavía no se creó ningún tag en ese repositorio, esto es esperable -- es el primer release. Creá el tag correspondiente en $REPOSITORIO antes de volver a correr el deploy." >&2
  exit 1
fi

if [ "$HTTP_STATUS" != "200" ]; then
  echo "validar-tag-en-github: la API de GitHub respondió con un código inesperado ($HTTP_STATUS) al consultar '$REPOSITORIO' tag '$TAG'." >&2
  exit 1
fi

echo "validar-tag-en-github: el tag '$TAG' existe en el repositorio '$REPOSITORIO' de GitHub."
