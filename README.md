# FlaskWeatherApp

Developed a flask app using Python3, SQLalchemy and deployed it on Kubernetes.
Used Jenkins servers on AWS for CI/CD pipeline.
Provisioned the architecture on AWS using Terraform.
Did configuratin management of Jenkins servers on AWS using Ansible.

## Steps to run

1. Clone the git repository.
2. cd in the repository and build the Dockerfile using `docker build -t <name of image you want to build>:<tag> .`
(example - `docker build -t flaskapp:latest .`)
3. Check the images present using `docker images`
4. Run the Dockerfile using `docker run -d -p <port_to_be_served>:<port_the_website_works> <name of image you want to build>:<tag>`
(example - `docker run -p 5000:5000 flaskapp:latest`)
5. Go to localhost:5000
6. The docker image can be found on Docker Hub - https://hub.docker.com/r/jack17529/weather

## Steps to deploy

1. Make a deployment.yaml file
2. The file has 2 parts the deployment part and the service part.
3. Make a namespace for the app `kubectl create ns flaskapp`
4. Deploy using `kubectl apply -f deployment.yaml -n flaskapp`
5. Check port`31000` and the weather app would be running.

## Setting up AWS

Infrastructure provisioning with Terraform and configuration management with Ansible.
Using aws-vault for keeping secrets.

https://github.com/jack17529/FlaskWeatherApp/tree/master/aws

## Setting Jenkins Pipeline

Set up jenkins pipeline with 3 jobs which are triggered from github webhook. Used Jenkins master and two slave servers on AWS.  
Tested the backend on staging server then deployed it in production using Jenkins Pipeline.  
Steps are present here - https://github.com/jack17529/FlaskWeatherApp/blob/master/jenkins/README.md
