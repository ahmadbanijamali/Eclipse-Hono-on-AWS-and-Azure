
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
git clone https://github.com/ahmadbanijamali/test.git
cd test
tar -zxvf eclipse-hono-1.0.0-chart.tar.gz -C /root/ 
echo

echo 
echo “####Deploying Eclipse Hono 1.0.0####”
./cd-backward
cd eclipse-hono-1.0.0
mkdir resources
helm dep update eclipse-hono/
helm template --name hono --namespace hono --output-dir resources eclipse-hono/
helm template --name hono --namespace hono --set prometheus.createInstance=false --set grafana.enabled=false --output-dir resources eclipse-hono/
kubectl create namespace hono
kubectl config set-context $(kubectl config current-context) --namespace=hono
kubectl apply -f ./resources -R
echo Done!
