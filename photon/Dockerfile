FROM eclipse-temurin:21-jre AS base
RUN apt-get update && apt-get install -y --no-install-recommends zstd wget \
    && rm -rf /var/lib/apt/lists/*
ARG PHOTON_VERSION=1.3.0
RUN wget -q -O /opt/photon.jar \
    https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar

# Imports the search index at image build time so the deployed image is self-contained.
FROM base AS import
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DUMP_URL=https://download1.graphhopper.com/public/asia/photon-dump-asia-1.0-latest.jsonl.zst
# Must cover the same area as the OSRM extract.
ARG COUNTRIES=my,sg,bn
RUN wget -q -O- "$DUMP_URL" | zstd -d | java -Xmx2g -jar /opt/photon.jar import \
    -import-file - -country-codes "$COUNTRIES" -data-dir /data

FROM eclipse-temurin:21-jre
COPY --from=base /opt/photon.jar /opt/photon.jar
COPY --from=import /data /data
EXPOSE 2322
CMD ["java", "-Xmx1g", "-jar", "/opt/photon.jar", "serve", "-data-dir", "/data", "-listen-ip", "0.0.0.0"]
