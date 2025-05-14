#!/bin/sh

set -e

SQLD_NODE="${SQLD_NODE:-primary}"
SQLD_DB_PATH="${SQLD_DB_PATH:-/data/iku.db}"
SQLD_HTTP_LISTEN_ADDR="${SQLD_HTTP_LISTEN_ADDR:-0.0.0.0:8080}"

# Start with base arguments
ARGS="--db-path $SQLD_DB_PATH --http-listen-addr $SQLD_HTTP_LISTEN_ADDR"

# Add node-specific arguments
case "$SQLD_NODE" in
  primary)
    SQLD_GRPC_LISTEN_ADDR="${SQLD_GRPC_LISTEN_ADDR:-0.0.0.0:5001}"
    ARGS="$ARGS --grpc-listen-addr $SQLD_GRPC_LISTEN_ADDR"
    ;;
  replica)
    ARGS="$ARGS --primary-grpc-url $SQLD_PRIMARY_URL"
    ;;
  standalone)
    ;;
esac

# Execute with the arguments
exec /app/sqld $ARGS
