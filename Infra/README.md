# Infra

Used Terraform with AWS to create manage infrastructure.  
Used aws-vault for keeping credentials safe and docker-compose to hard set the version of terraform as new version of terraform gets released in every 2 weeks.  

## Steps Docker

Should be able to run docker without `sudo`

1. `sudo groupadd docker`
2. `sudo gpasswd -a $USER docker`
3. `newgrp docker`
4. `docker run hello-world` to check.

## Steps Docker Compose

1. 

## Steps Terraform

1. `docker-compose run --rm tf init` to initialize terraform.
2. `docker-compose run --rm tf fmt` to format the `main.tf` file.
3. `docker-compose run --rm tf validate` to validate the `main.tf` file.
