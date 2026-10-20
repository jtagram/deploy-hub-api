#!/usr/bin/env bash
set -u

if [ "$#" -ne 2 ]; then
  echo "validar-rama: se esperaban exactamente dos argumentos (la ref actual completa y la rama requerida)" >&2
  exit 1
fi

CURRENT_REF="$1"
REQUIRED_BRANCH="$2"

if [ -z "$REQUIRED_BRANCH" ]; then
  echo "validar-rama: la rama requerida no está definida" >&2
  exit 1
fi

if [ "$CURRENT_REF" != "refs/heads/$REQUIRED_BRANCH" ]; then
  echo "validar-rama: este workflow solo puede ejecutarse desde la rama \"$REQUIRED_BRANCH\" de deploy-hub-api, pero se lanzó desde \"$CURRENT_REF\". Elegí la rama \"$REQUIRED_BRANCH\" en \"Use workflow from\"." >&2
  exit 1
fi

exit 0
