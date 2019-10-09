Prerequisities before running the AWS k8s cluster deployment: 
* a fresh EC2 Ubuntu instance on AWS
* an IAM user/role with Route53, EC2, IAM and S3 full access and attached to the EC2 instance
* a Route53 private hosted zone, example used is appstacleoulu.fi on eu-west-3 region

First, root the instnace:
```
sudo su -
```

Then...
```
git clone https://github.com/ahmadbanijamali/Hono-deployment-on-AWS.git && \
cd Hono-deployment-on-AWS/ && \
chmod +x AWSClusterDeployment.sh && \
./AWSClusterDeployment.sh
```
