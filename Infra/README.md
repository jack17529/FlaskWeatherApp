# Infra

Used Terraform with AWS to create manage infrastructure.  
Used aws-vault for keeping credentials safe and docker-compose to hard set the version of terraform as new version of terraform gets released in every 2 weeks.

## Prerequisites

1. Install `aws-cli`
2. Install `docker` and `docker-compose`
3. Install `aws-vault`

## Steps Docker

Should be able to run docker without `sudo`

1. `sudo groupadd docker`
2. `sudo gpasswd -a $USER docker`
3. `newgrp docker`
4. `docker run hello-world` to check.

## Steps Docker Compose

1. `docker-compose -f docker-compose.yml config` to check your docker-compose file.
2. `docker-compose` commands should work without sudo.

## AWS

1. Need to give the perssion to the user that is goign to be terraform to be able to login and other permissions.
2. Create credentials and use them with aws-vault.
3. You also need to generate a public key in your ssh folder using `ssh-keygen -t rsa` and use it to access the terraform-user on AWS.

## Steps aws-vault

1. `aws-vault add ss` to add an account.
2. `aws-vault exec ss -- env | grep AWS` should show the credentials in the environment.
3. `aws-vault login ss` should make you login otherwise terraform-user won't be able to access the aws too.
4. `aws-vault exec ss --duration=12h` to set the duration for expiration of credentials.

## Steps Terraform

0. Use `nano ~/.aws/config` to set up `MFA` and `region`.
1. `docker-compose run --rm tf init` to initialize terraform.
2. `docker-compose run --rm tf fmt` to format the `main.tf` file.
3. `docker-compose run --rm tf validate` to validate the `main.tf` file.
4. `docker-compose run --rm tf plan` to plan.
5. `docker-compose run --rm tf apply`
6. `docker-compose run --rm tf destroy`
7. In case of any unexpected errors delete the `.terraform` folder and try `init` command again.
