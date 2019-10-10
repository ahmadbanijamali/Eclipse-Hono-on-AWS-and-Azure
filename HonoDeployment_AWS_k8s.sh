
echo
echo "#########################################"
echo "#########################################"
echo "###########     Eclipse Hono     ########"
echo "###### Eclipse Hono 1.0 on AWS k8s ######"
echo "#########################################"
echo "#########################################"
echo
echo "####### Initialization #######"

#


echo ”####installing Helm####”
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init
#kubectl create serviceaccount --namespace kube-system tiller
#kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
echo Done!

echo
echo “####Clone the Eclipse Hono Helm chart####”
wget http://download.eclipse.org/hono/eclipse-hono-1.0-M7-chart.tar.gz
tar -zxvf eclipse-hono-1.0-M7-chart.tar.gz -C /root/
cd
echo

echo 
echo “####Deploying Eclipse Hono 1.0####”
cd eclipse-hono-1.0-M7/deploy/ 
helm dep update helm/eclipse-hono 
helm template --name hono --namespace hono --output-dir . helm/eclipse-hono 
kubectl create namespace hono  
kubectl config set-context $(kubectl config current-context) --namespace=hono  
find . -path "./eclipse-hono/*" -name crd*.yaml -exec kubectl apply -f {} \;  
kubectl apply -f ./eclipse-hono -R
echo Done!
