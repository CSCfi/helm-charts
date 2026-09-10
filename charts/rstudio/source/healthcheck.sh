#!/bin/bash
# Used as the container's liveness/readiness probe.
# Fails (non-zero exit) if either RStudio or Shiny stops responding,
# regardless of whether their process is still technically alive.
set -e

curl -fsS --max-time 3 http://localhost:8787/ >/dev/null
curl -fsS --max-time 3 http://localhost:3838/ >/dev/null
