#!/bin/bash -e

function usage() {
    echo "$0 <usage>"
    echo " "
    echo "options:"
    echo -e "--help \t Show options for this script"
    echo -e "--deploy \t Deploy the application."
    echo -e "--deploy-all \t Deploy the application."
    echo -e "--delete \t Delete the nginx deployment."
    echo -e "--delete-all \t Delete entire deployment."
    echo -e "--scale \t Scale the application - example: --scale 4"
}

function delete_deployment() {
  echo "Removing deployment Host-Monitor..."
  kubectl delete -f templates/nginx-flask-deployment.yml;
  kubectl delete -f templates/nginx-flask-service.yml 
}

function delete_all() {
  echo "Removing entire deployment."
  #kubectl delete -f templates/
}

function deploy() {
  echo "Deploying Host-Monitor..."
  kubectl apply -f templates/nginx-flask-deployment.yml --validate=false;
  kubectl apply -f templates/nginx-flask-service.yml 
}

function deploy_all() {
  echo "Deploying Host-Monitor..."
  kubectl apply -f templates/ --validate=false;
}

function scale_application() {
  echo "Scaling Host-Monitor to ${SCALE}..."
  kubectl scale --replicas=${SCALE} -f templates/nginx-flask-deployment.yml
}

# Read the options from cli input
TEMP=`getopt -o h --longoptions help,deploy:,deploy-all:,delete:,delete-all:,scale: -n $0 -- "$@"`
eval set -- "${TEMP}"

echo "Check: ${TEMP}"

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
        --delete)
            DELETE="$2";
            shift 2
            ;;
        --deploy_all)
            DEPLOY_ALL="$2";
            shift 2
            ;;
        --delete_all)
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

if [[ ${DELETE} == "TRUE" ]];then
  echo "running delete_deployment"
  delete_deployment
fi

if [[ ${DELETE_ALL} == "TRUE" ]];then
  echo "running delete_all"
  #delete_all
fi

if [[ -n ${SCALE} ]]; then
  echo "scaling app"
  scale_application
fi

