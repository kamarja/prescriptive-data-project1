#!/bin/bash -e

function usage() {
    echo "$0 <usage>"
    echo " "
    echo "options:"
    echo -e "--help \t Show options for this script"
    echo -e "--deploy \t Deploy the application."
    echo -e "--delete \t Delete the deployment."
    echo -e "--scale \t Scale the application - example: --scale 4"
}

function delete_deployment() {
  echo "Removing deployment Host-Monitor..."
  #kubectl delete -f ../templates/
}

function deploy() {
  echo "Deploying Host-Monitor..."
  kubectl apply -f ../templates/
}

function scale_application() {
  echo "Scaling Host-Monitor to ${SCALE}..."
  #kubectl scale --replicas=${SCALE} -f ../templates/nginx-flask-deployment.yml
}

# Read the options from cli input
TEMP=`getopt -o h --longoptions help,deploy:,delete:,scale: -n $0 -- "$@"`
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

if [[ ${DELETE} == "TRUE" ]];then
  echo "running delete_deployment"
  #delete_deployment
fi

if [[ -n ${SCALE} ]]; then
  echo "scaling app"
  #scale_application
fi

