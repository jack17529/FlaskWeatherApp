# jenkins

1. Used ssh to connect master to slave nodes(staging and production) using the pem file for authentication in `global security settings`.  
2. Remote root directory will be `/home/ubuntu/jenkins`.  
3. Host will be the slave's public ip.  
4. Used credentials for ssh verfication as the `.pem` file for connecting to the slave server on aws.
5. Host Key Verification Strategy will be `Manually trusted key Verification Strategy`
6. DON'T check mark `Require manual verification of initial connection`


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
sudo docker rm -f $(sudo docker ps -a -q) || true
sudo docker build /home/ubuntu/jenkins/workspace/Git-Job -t app
sudo docker run -it -p 5000:5000 -d app
```
3. Trigger `Push-Production` job only if the build is stable.

### Push-Production
1. Choose `Restrict where this project can be run` and choose `production`.

2. Used `GitHub hook trigger for GITScm polling` for using git-webhook.

3. Executes this shell.
```
sudo docker rm -f $(sudo docker ps -a -q) || true
sudo docker build /home/ubuntu/jenkins/workspace/Push-Production -t app
sudo docker run -it -p 80:5000 -d app
```

NOTE - don't forget to change the `security groups` for the staging and production instances to access the website.

### Plugins Used

1. Git Plugin
2. Pipeline Plugin
