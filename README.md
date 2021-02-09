# prescriptive-data-project1
Prescriptive Data Project 1

## Application layout

- It is assumed that you have Minikube and Docker running and that you are running on a Mac or other Unix-like system.

- App: `host-monitor` - this is where the application files are located. The Dockerfiles for the applications are here as well. 
- DB: The `db` directory pertains to the database for the application. The `server` directory has the nginx and flask backend files and the `vue-frontend` directory has the frontend Vue application files. 
- Scripts: `scripts` - Helper scripts are located here.

## A few manual steps

- Install Docker and minikube
- Run setup script: `./scripts/setup.sh`
- add the hostname to your /etc/hosts. 
  ```bash
  echo "$(minikube ip) pdata.world" | sudo tee -a /etc/hosts
  ```
- Run the minikube tunnel for ambassador.
  ```bash
  minikube tunnel
  ```
## Setup Development Environment

Tools for helping you setup the development environment are located in the scripts directory. Use the `./scripts/setup.sh` before deploying.

## Local Development

- The application files are located in the `host-monitor` directory. 

## Kubernetes Deployment

The Kubernetes template files are located in the `templates` directory. Use the
script in `scripts/manage_deployment.sh` for managing the deployment.

```bash
options:
--help           Show options for this script
--deploy-db      Deploy the database.
--deploy         Deploy the application.
--deploy-all     Deploy the entire application.
--delete         Delete the nginx deployment.
--delete-all     Delete entire deployment.
--scale          Scale the application - example: --scale 4
```

## Demo
- After running the setup script, run the following commands.
```bash

# First setup the database.
./scripts/manage_deployment.sh --deploy-db TRUE

# Double check that pg_hba.conf file has correct network.
# We assumed 172.17.0.0 and 10.0.0.0. If it's incorrect, correct it and restart postgres
pkill -HUP postgres
```

```bash
# This will deploy the application
./scripts/manage_deployment.sh --deploy TRUE

# Scale 
./scripts/manage_deployment.sh --scale 4

# Delete the application.
./scripts/manage_deployment.sh --delete TRUE
```

## TODO
- Possible improvements
  - mount your desired pg_hba file as a config map. This will eliminate the manual step of updating it. 
  - Setup a hook so that each pod remove their entry from the db before shutting down.
  - Add `vault` to the application to store secrets.
  - Implement feature to `scale` pods by a certain value when the add button is clicked.