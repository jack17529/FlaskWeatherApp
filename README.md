# DockerizingFlaskWeatherApp

Implemented CI/CD pipeline using Docker for Flask weather app.
The docker image can be found on Docker Hub - https://hub.docker.com/r/jack17529/weather

## Steps to install

1. Clone the git repository.
2. cd in the repository and build the Dockerfile using - sudo docker build -t weather .
3. Runn the Dickerfile using - sudo docker run -d -p 127.0.0.1:5000:5000 weather:latest
4. Go to http://127.0.0.1:5000
