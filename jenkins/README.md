# jenkins
Used ssh to connect master to slave nodes(staging and production) using the pem file for authentication in `global security settings`.


Jobs in the pipeline.  
1. Git-Job
2. Build-Job
3. Push-Production 

## Steps

### Git-Job
0. Choose `Restrict where this project can be run` and choose `staging`.

1. Just copies the code to the staging server using `https://github.com/jack17529/FlaskWeatherApp.git` as the repository url.

2. Used `GitHub hook trigger for GITScm polling` for using git-webhook.

3. Triggers `Build-Project` job if executed successfully.

### Build-Project
1. Choose `Restrict where this project can be run` and choose `staging`.

2. Executes this shell.
```
sudo docker rm -f $(sudo docker ps -a -q)
sudo docker build /home/ubuntu/jenkins/workspace/Git-Job -t app
sudo docker run -it -p 5000:5000 -d app
```
3. Trigger `Push-Production` job only if the build is stable.

### Push-Production
1. Choose `Restrict where this project can be run` and choose `production`.

2. Used `GitHub hook trigger for GITScm polling` for using git-webhook.

3. Executes this shell.
```
sudo docker rm -f $(sudo docker ps -a -q)
sudo docker build /home/ubuntu/jenkins/workspace/Push-Production -t app
sudo docker run -it -p 80:5000 -d app
```
