#Setup Kubernetes (K8s) Cluster on AWS

# Make the script fail if a command fails
set -e

echo
echo “#####Creating Ubuntu EC2 instance#####”
sudo apt-get update

echo
echo “#####Installing AWSCLI#####”
curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip
sudo apt install unzip python
sudo unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
echo

echo
echo “#####Installing kubectl#####”
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo

echo
echo “#####Installing Docker#####”
sudo apt-get install docker.io -y
echo


#echo
#echo “#####Installing Minikube#####”
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
# chmod +x minikube 
# mv minikube /usr/local/bin/
# minikube start --vm-driver=none
# minikube status
#echo

echo
echo “#####We need to have an IAM user/role with Route53, EC2, IAM and S3 full access#####”
echo “#####the role should be attached to the ubuntu instance#####”
aws configure
echo

echo
echo “#####Installing kops on ubuntu instance#####”
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
echo

echo
echo “#####We need to have a Route53 private hosted zone#####” 
echo 

echo
echo “#####Creating an S3 bucket”
aws s3 mb s3://dev.k8s.appstacleoulu.fi
echo

echo
echo “#####Expose environment variable#####”
export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
echo

echo
echo “#####Creating sshkeys before creating cluster#####”
ssh-keygen
echo

echo
echo “#####Creating kubernetes cluster definitions on S3 bucket#####”
kops create cluster \
    --state "s3://dev.k8s.appstacleoulu.fi" \
     --zones "eu-west-3c" \
     --master-count 1 \
     --master-size=t2.medium\
     --node-count 2 \
     --node-size=t2.medium \
     --name dev.k8s.appstacleoulu.fi \
     --dns private
     --yes
echo

echo
echo “#####Creating kubernetes cluser#####”
kops update cluster dev.k8s.appstacleoulu.fi –yes
echo

echo
echo “#####Validating your cluster”
kops validate cluster
echo

#To list nodes
#kubectl get nodes

#To delete k8s
#kops delete cluster dev.k8s.appstacleoulu.fi --yes
#To access the master k8s:
#cd .ssh
#ssh -i id_rsa admin@(Public DNS)
