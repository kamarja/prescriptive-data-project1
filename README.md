# prescriptive-data-project1
Prescriptive Data Project 1

## Application layout

- It is assumed that you have Minikube running and that you are running on a Mac or other Unix-like system.

`host-monitor` - this is where the application files are located. The Dockerfiles for the applications are here as well. 
`db`           - The Postgres database for the application.
`server`       - The nginx files are located here.	
`vue-frontend` - The frontend files are here. 

## A few manual steps

- Install Docker and minikube
- Run setup script: `./scripts/setup.sh`
- add the hostname to your /etc/hosts. 
  ```bash
  echo "$(minikube ip) pdata.world" | sudo tee -a /etc/hosts
  ```
- Run the minikube tunnel for ambassador
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
--deploy         Deploy the application.
--deploy-all     Deploy the application.
--delete         Delete the nginx deployment.
--delete-all     Delete entire deployment.
--scale          Scale the application - example: --scale 4
```
