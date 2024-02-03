# Automate image updates of Kubernetes pods with git push
flow
1. git push
2. check build on circleci
3. If there is no problem with the build, push to ECR
4. set image deployment on kubernetes

Yaml file manifests are not managed.

## environment
- kubernetes
    - v1.28.2
- circle ci
- github
- container registry
    - ECR private

## Prerequisites
- Already in operation with Kubernetes.
- CircleCI and git are already connected
- An ECR repository has already been created.
- [ServiceAccount](https://github.com/a5ro5a/k8s-create-svcaccount) has already been created.

## circle ci env settings
Projects > Project Settings > Environment Variables

| Name | Value |
| ---- | ----- |
| AWS_ACCESS_KEY_ID | AWS API ID|
| AWS_ACCOUNT_ID|AWS Account ID|
| AWS_DEFAULT_REGION |region of ECR|
| AWS_SECRET_ACCESS_KEY |AWS API key|
| DEPLOYMENT_NAME |deployement namespace of kubernetes. example. testapps|
| ECR_IMAGE_NAME |repository name of ECR|
| KUBERNETES_TOKEN |$TOKEN of serviceaccount of kubernetes|
| KUBERNETES_SERVER | What you obtained earlier as $KUBERNETES_SERVER (value of server: listed in ~/.kube/config)|
| KUBERNETES_CLUSTER_CERTIFICATE |The value of certificate-authority-data: in ~/.kube/config|

## tutorial
### download
```bash
git clone https://github.com/a5ro5a/k8s-deploy-with-circleci-ecr
```

### create sample app
```bash
cat <<END|kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
    name: testapps
END
```
```bash
kubectl create deployment -n testapps nginx --image=nginx:latest
```
```bash
kubectl get pods/nginx -n testapps
```

### change code
#### edit version
```bash
vi .env
```
#### Dockerfile
__The Dockerfile is a sample, so feel free to modify it as you like.__

### push
- git push to_your_repository
- check circle ci Pipelines of project.
- check your ecr repository.
- check version of pods on you kubernetes.

## check
```bash
kubectl describe deployment/testapps | grep -i image
```
It is successful if the tag number changes from latest to 0.0.0

You can also check the file by logging into the pod.
```bash
kubectl exec -it pods/nginx-xxxxxx -n testapps -- cat /usr/share/nginx/html/test.html
```

### delete samaple app
```bash
kubectl delete namespace testapps
```

