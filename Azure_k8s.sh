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


echo
echo "#####Installing kubectl#####"
cd
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo


az provider register -n Microsoft.ContainerService

echo
echo "#####creating the resource group and cluster#####"
az group create --name oulu --location eastus
az aks create --resource-group oulu --name azure --node-count 1 --generate-ssh-keys
az aks install-cli
az aks get-credentials --resource-group oulu --name azure
echo


