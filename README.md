Here is an example of Eclipse Hono deployment on AWS k8s cluster

Prerequisities before running the AWS k8s cluster deployment: 
* a fresh EC2 Ubuntu instance on AWS
* an IAM user/role with Route53, EC2, IAM and S3 full access and attached to the EC2 instance
* a Route53 private hosted zone, example used is appstacleoulu.fi on eu-west-3 region

SSH to your cluster and follow this instruction: 

First, root the instnace:
```
sudo su -
export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
```

And then..
```
git clone https://github.com/ahmadbanijamali/Hono-deployment-on-AWS.git && \
cd Hono-deployment-on-AWS/ && \
chmod +x AWSClusterDeployment.sh && \
./AWSClusterDeployment.sh
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

To delete the k8s cluster:
```
export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
kops delete cluster dev.k8s.appstacleoulu.fi --yes
```

To access the K8s master node:
```
cd .ssh
ssh -i id_rsa admin@(Public DNS)
```

To deploy the Eclipse Hono on the AWS clusters:
```
chmod +x HonoDeployment_AWS_k8s.sh && \
./HonoDeployment_AWS_k8s.sh
```

To get Hono services and pods
```
kubectl get service -n hono
kubectl get pods -n hono
```
