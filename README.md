
## Deploying AWS k8s cluster

#### Prerequisities before running the AWS k8s cluster deployment: 
* a fresh [EC2 Ubuntu instance on AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html)
* an IAM user/role with Route53, EC2, IAM and S3 full access and attached to the EC2 instance
* a Route53 private hosted zone, example used is appstacleoulu.fi on eu-west-3 region

#### SSH to your cluster and follow this instruction: 

First, root the instnace:
```
sudo su -
export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
```

And then in "Eclipse-Hono-on-AWS-and-Azure" directory..
```
chmod +x AWS_k8s.sh && \
./AWS_k8s.sh
```

Enter your EC2 instance zone when it required.

Finally, create kubernetes cluser:
```
kops update cluster dev.k8s.appstacleoulu.fi --yes
```
It takes 5-10 min to create the AWS k8s cluster.


To validating your cluster:
```
kops validate cluster
```

And to list the nodes:
```
kubectl get nodes
```

To access the K8s master node:
```
cd .ssh
ssh -i id_rsa admin@(Public DNS)
```

To delete the k8s cluster:
```
export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
kops delete cluster dev.k8s.appstacleoulu.fi --yes
```
## Deploying Azure k8s cluster

#### Prerequisites
* an [Azure subscription](https://azure.microsoft.com/en-us/get-started/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed to setup the infrastructure.

login to your Azure CLI and root 
```
sudo su -
```

Then..
```
chmod +x Azure_k8s.sh && \
./Azure_k8s.sh
```

## Deploying the Eclipse Hono on the AWS/Azure k8s clusters:
```
chmod +x Hono_deployment.sh && \
./Hono_deployment.sh
```

To get Hono services, pods, and endpoints
```
kubectl get pods,svc,ep -n hono
```
To describe the pod and get logs
```
kubectl describe pod ... -n hono
kubectl -n hono logs ...
```
