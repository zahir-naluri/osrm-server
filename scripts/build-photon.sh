#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
BUILD=$(date +%Y%m%d)
DUMP=https://download1.graphhopper.com/public/asia/photon-dump-asia-1.0-latest.jsonl.zst
COUNTRIES=my,sg,bn   # must cover the same area as the OSRM extract

docker compose run --rm photon sh -c \
  "wget -q -O- $DUMP | zstd -d | java -Xmx2g -jar /opt/photon.jar import \
     -import-file - -country-codes $COUNTRIES -data-dir /data/$BUILD"

ln -sfn "$BUILD" photon-data/current
docker compose restart photon