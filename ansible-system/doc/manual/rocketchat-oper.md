rocketchat upgrade version

cd /rocket/docker/it
sudo docker pull rocketchat/rocket.chat:latest
sudo docker-compose up -d rocketchat-gl
sudo docker logs -f docker_rocketchat-gl_1

/rocket-gl/docker