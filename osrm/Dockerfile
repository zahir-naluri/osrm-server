ARG OSRM_IMAGE=ghcr.io/project-osrm/osrm-backend:v26.10.0-debian

# Builds the routing graph at image build time so the deployed image is self-contained.
FROM ${OSRM_IMAGE} AS build
ARG PBF_URL=https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf
WORKDIR /data
ADD ${PBF_URL} region.osm.pbf
# car.lua = driving profile. MLD = fast updates; use osrm-contract + "--algorithm ch" for slightly faster queries.
RUN osrm-extract -p /opt/car.lua region.osm.pbf \
    && osrm-partition region.osrm \
    && osrm-customize region.osrm \
    && rm region.osm.pbf

FROM ${OSRM_IMAGE}
COPY --from=build /data /data
EXPOSE 5000
CMD ["osrm-routed", "--algorithm", "mld", "/data/region.osrm"]
