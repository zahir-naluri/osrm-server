#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p osrm-data
cd osrm-data
BUILD=$(date +%Y%m%d)
IMAGE=ghcr.io/project-osrm/osrm-backend:v26.10.0-debian
mkdir -p "$BUILD"

wget -q -O "$BUILD/region.osm.pbf" \
  https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf

# car.lua = driving profile. MLD = fast updates; use osrm-contract + "--algorithm ch" for slightly faster queries.
docker run --rm -v "$PWD/$BUILD:/data" $IMAGE osrm-extract -p /opt/car.lua /data/region.osm.pbf
docker run --rm -v "$PWD/$BUILD:/data" $IMAGE osrm-partition /data/region.osrm
docker run --rm -v "$PWD/$BUILD:/data" $IMAGE osrm-customize /data/region.osrm
rm "$BUILD/region.osm.pbf"

ln -sfn "$BUILD" current
docker compose -f ../docker-compose.yml restart osrm