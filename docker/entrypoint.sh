#!/bin/bash

set -euo pipefail

if [ "${1:0:1}" = "-" ]; then
    set -- openpilot-alpine "$@"
fi

exec "$@"