# FlaskWeatherApp

Deployed Flask weather app made using Python 3 on Kubernetes.
The docker image can be found on Docker Hub - https://hub.docker.com/r/jack17529/weather

## Steps to run

1. Clone the git repository.
2. cd in the repository and build the Dockerfile using `docker build -t <name of image you want to build>:<tag> .`
example - `docker build -t flaskapp:latest .`
3. Check the images present using `docker images`
4. Run the Dockerfile using `docker run -d -p 127.0.0.1:5000:5000 <name of image you want to build>:<tag>`
example - `docker run --p 127.0.0.1:5000:5000 flaskapp:latest`
5. Go to http://127.0.0.1:5000

## Steps to deploy

1. Make a namespace for the app `kubectl create ns flaskapp`
2. Deploy using `kubectl apply -f k8s-specifications -n flaskapp`
3. Check port`31000` and the weather app would be running.
