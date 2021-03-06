#!/bin/bash -e

function usage() {
    echo "$0 <usage>"
    echo " "
    echo "options:"
    echo -e "--help \t Show options for this script"
    echo -e "--deploy \t Deploy the application."
    echo -e "--deploy-db \t Deploy the database."
    echo -e "--deploy-all \t Deploy the entire application."
    echo -e "--delete \t Delete the nginx deployment."
    echo -e "--delete-all \t Delete entire deployment."
    echo -e "--scale \t Scale the application - example: --scale 4"
}

function delete_deployment() {
  echo "Clearing db table"
  remove_stale_hosts

  echo "Removing deployment Host-Monitor..."
  kubectl delete -f templates/nginx-flask-deployment.yml;
  kubectl delete -f templates/nginx-flask-service.yml 
}

function delete_all() {
  echo "Clearing db table"
  remove_stale_hosts

  echo "Removing entire deployment."
  remove_stale_hosts
  kubectl delete -f templates/
}

function deploy() {
  echo "Deploying Host-Monitor..."
  kubectl apply -f templates/nginx-flask-deployment.yml --validate=false;
  kubectl apply -f templates/nginx-flask-service.yml 
  kubectl apply -f templates/nginx-ingress.yml
}

function deploy_all() {
  echo "Deploying Host-Monitor..."
  deploy_db
  kubectl apply -f templates/ --validate=false;
}

function scale_application() {
  echo "Scaling Host-Monitor to ${SCALE}..."
  kubectl scale --replicas=${SCALE} -f templates/nginx-flask-deployment.yml
}

function deploy_db() {
  echo "Deploying Database..."
  kubectl apply -f templates/nginx-flask-deployment.yml --validate=false;
  kubectl apply -f templates/nginx-flask-service.yml 
  kubectl apply -f templates/persistent-volume.yml
  kubectl apply -f templates/persistent-volume-claim.yml
  kubectl apply -f templates/secret.yml
  kubectl apply -f templates/postgres-configmap.yml
  kubectl apply -f templates/postgres-deployment.yml
  kubectl apply -f templates/postgres-service.yml
  POSTGRES=$(kubectl get pods| grep postgres | awk {'print $1'})
  kubectl exec -it $POSTGRES -- bash -c 'echo "host    all             all             172.17.0.0/16            trust" >> /var/lib/postgresql/data/pg_hba.conf;'
  kubectl exec -it $POSTGRES -- bash -c 'echo "host    all             all             10.0.0.0/24            trust" >> /var/lib/postgresql/data/pg_hba.conf; pkill -HUP postgres'
}



function remove_stale_hosts() {
  POSTGRES=$(kubectl get pods| grep postgres | awk {'print $1'})
  kubectl cp ./scripts/clear_table.sql "$POSTGRES":/tmp/clear_table.sql
  kubectl exec -it $POSTGRES -- bash -c 'psql -U postgres -d hosts -f /tmp/clear_table.sql'
}

# Read the options from cli input
TEMP=`getopt -o h --longoptions help,deploy:,deploy-db:,deploy-all:,delete:,delete-all:,scale: -n $0 -- "$@"`
eval set -- "${TEMP}"

if [[ $# == 1 ]]; then echo "No input provided! type ($0 --help) to see usage help" >&2 ; exit 1 ; fi


while true; do
    case "$1" in
        -h | --help)
            usage
            exit 1
            ;;
        --deploy)
            DEPLOY="$2";
            shift 2
            ;;
        --deploy-db)
            DEPLOY_DB="$2";
            shift 2
            ;;
        --delete)
            DELETE="$2";
            shift 2
            ;;
        --deploy-all)
            DEPLOY_ALL="$2";
            shift 2
            ;;
        --delete-all)
            DELETE_ALL="$2";
            shift 2
            ;;
        --scale)
            SCALE="$2";
            shift 2
            ;;
        --)
            break
            ;;
        *)
            break
            ;;
    esac
done

if [[ ${DEPLOY} == "TRUE" ]];then
  deploy
fi

if [[ ${DEPLOY_ALL} == "TRUE" ]];then
  deploy_all
fi

if [[ ${DEPLOY_DB} == "TRUE" ]];then
  deploy_db
fi

if [[ ${DELETE} == "TRUE" ]];then
  echo "running delete_deployment"
  delete_deployment
fi

if [[ ${DELETE_ALL} == "TRUE" ]];then
  echo "running delete_all"
  delete_all
fi

if [[ -n ${SCALE} ]]; then
  echo "scaling app"
  scale_application
fi

