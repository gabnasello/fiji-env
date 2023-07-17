# Docker Image for image analysis in Fiji (with GUI)

# Build the docker images

From the project folder, run the command below:

```bash build.sh```

# Run docker container

## Standard approach (recommended)

From the project folder, run the command below:

```docker-compose up -d```

## Alternative approach

You can run the following command:

```docker run -d -p 3000:3000 --name fiji gnasello/fiji-env:latest```

# Use the Docker

Open ```localhost:3000``` in your browser to get a virtual desktop.