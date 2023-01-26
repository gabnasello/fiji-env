# Docker Image for image analysis in Fiji (with GUI)

# Build the docker images

From the project folder, run the command below:

```bash build.sh```

# Run docker container

## Standard approach (recommended)

From the project folder, run the command below:

```docker-compose up -d```

You can get an interactive shell of the running docker-compose service with (slicer is the {SERVICENAME}):

```docker-compose exec fiji bash```

Then close the container with:

```docker-compose down```

## Alternative approach

You can run the following command:

```docker run -d -p 8080:8080 --volume $HOME:/home/host_home --workdir /home/host_home --name fiji gnasello/fiji-env:latest```

To connect to a container that is already running ("slicer" is the container name):

```docker exec -it fiji /bin/bash```

After use, you close the container with:

```docker rm -f fiji```

# Use the Docker

Open ```localhost:8080``` in your browser and click the "X11 Session" button

# Acknowledgements

This Docker was inspired by a post on [Accessing GUI Applications Using Docker](https://www.digitalocean.com/community/tutorials/how-to-remotely-access-gui-applications-using-docker-and-caddy-on-debian-9#step-2-mdash-setting-up-the-openbox-menu)