#! /bin/bash -x
set -e

source ~/app/.env

echo "$KUBERNETES_CLUSTER_CERTIFICATE" | base64 --decode > cert.crt

REGISTRY_URL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
REPOSITORY_URL=${REGISTRY_URL}/${ECR_IMAGE_NAME}

aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin $REGISTRY_URL

./kubectl \
  --kubeconfig=/dev/null \
  --server=$KUBERNETES_SERVER \
  --certificate-authority=cert.crt \
  --token=$KUBERNETES_TOKEN \
  set image deployment/${_DEPLOYMENT_NAME} -n ${_NAMESPACE} ${_DEPLOYMENT_NAME}=${REPOSITORY_URL}:${_VERSION}
  # Please change it to suit your environment
  #set image deployment/${_DEPLOYMENT_NAME} -n ${_NAMESPACE} ${ECR_IMAGE_NAME}=${REPOSITORY_URL}:${_VERSION}
