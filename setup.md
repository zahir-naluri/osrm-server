# Local OSRM

```
# download osrm data of MY, SG & Brunei
bash ./scripts/build-osrm.sh
```

# Local Photon

```
# download matching osrm data of MY, SG & Brunei for photon
bash ./scripts/build-photon.sh - takes quite some time to download the data dump. > 2GB
```

# Run locally

```
docker compose up -d
curl "http://localhost:5001/route/v1/driving/101.6869,3.1390;101.7123,3.1579"   # OSRM
curl "http://localhost:2322/api?q=kuala+lumpur"                                 # Photon
```

# Deployment (staging)

Pushing to `staging` runs `.github/workflows/staging.yml`, which builds `osrm/Dockerfile` and
`photon/Dockerfile` (data is downloaded and baked into the images), pushes them to ECR and deploys
`ecs-task-def-ec2.json` as the `osrm-server-service` ECS service on the EC2 cluster.

The service is internal only. Other services reach it on the EC2 host's private IP:

- OSRM: `http://<host>:5001`
- Photon: `http://<host>:2322`

## Data updates

OSM data is only refreshed when you redeploy. A scheduled trigger in the workflow (for example,
weekly) would keep it current.

## What happens on setup

- Download osrm + photon data to the directory .osm.pbf for Malaysia, Singapore & Brunei
- - Certificate extends to these 3 countries as per some reference. But not sure if this is still applicable now or not
- - https://kaotim.my/wp-content/uploads/2026/06/STMAB-Certificate-Wording-Kaotim-Car-ENG.pdf
    ![alt text](image.png)
- photon data will be used to reverse geocode location & get location suggestions. routes /get-location & /get-suggestions
- osrm data (particulary car.lua) will be used when implementing driving line between 2 points in the map. Currently, its not being used directly as of telebantuan 3rd Nov 2026
