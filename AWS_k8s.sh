echo
echo "######################################################"
echo "######################################################"
echo "#########   Setup Kubernetes Cluster on AWS  #########"
echo "######################################################"
echo "######################################################"
echo
echo "########## Initialization ##########"



# Make the script fail if a command fails
set -e

echo
apt-get update

echo
echo "#####Installing AWSCLI#####"
curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip
apt install unzip python
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
echo

echo
echo "#####Installing kubectl#####"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
echo

echo
echo "#####Installing Docker#####"
apt-get install docker.io -y
echo


#echo
#echo "#####Installing Minikube#####"
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
#chmod +x minikube 
#mv minikube /usr/local/bin/
#minikube start --vm-driver=none
#minikube status
#echo

echo
echo "#####Configuring the role#####"
aws configure
echo

echo
echo "#####Installing kops on ubuntu instance#####"
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops
echo

echo
echo "#####We need to have a Route53 private hosted zone#####"
echo 

echo
echo "#####Creating an S3 bucket"
aws s3 mb s3://dev.k8s.appstacleoulu.fi
echo Done!

#echo
#echo "#####Expose environment variable#####"
#export KOPS_STATE_STORE=s3://dev.k8s.appstacleoulu.fi
#echo Done!

echo
echo “#####Creating sshkeys before creating cluster#####”
ssh-keygen
echo

echo
echo "####Creating kubernetes cluster definitions on S3 bucket####"
kops create cluster \
    --state "s3://dev.k8s.appstacleoulu.fi" \
     --zones "eu-west-3c" \
     --master-count 1 \
     --master-size=t2.xlarge\
     --node-count 2 \
     --node-size=t2.xlarge \
     --name dev.k8s.appstacleoulu.fi \
     --dns private
     --yes
