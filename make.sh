NAMESPACE=staging-1-3

function create-secrets(){
    kubectl create secret -n $NAMESPACE generic db-user-pass  --from-file=./private/password.txt
    kubectl create secret -n $NAMESPACE generic odatests-tests-bot-password  --from-file=./private/testbot-password.txt
    kubectl create secret -n $NAMESPACE generic odatests-secret-key  --from-file=./private/secret-key.txt
    kubectl delete secret -n $NAMESPACE minio-key
    kubectl create secret -n $NAMESPACE generic minio-key  --from-file=./private/minio-key.txt 
    kubectl create secret -n $NAMESPACE generic jena-password  --from-file=./private/jena-password.txt
    kubectl create secret -n $NAMESPACE generic logstash-entrypoint  --from-file=./private/logstash-entrypoint.txt
    kubectl create secret -n $NAMESPACE generic gateway-secret  --from-file=gateway-secret.txt=$HOME/gateway-secret-hexified

    kubectl delete secret -n $NAMESPACE dda-token
    kubectl create secret -n $NAMESPACE generic dda-token  --from-file=dda-token=$HOME/.dda-token
}

function install() {
    set -x
    helm -n ${NAMESPACE:?} install  oda-dqueue . --set image.tag="$(cd dqueue; git describe --always)"
}

function upgrade() {
    set -x
    helm upgrade -n ${NAMESPACE:?} oda-dqueue . --set image.tag="$(cd dqueue; git describe --always)" --wait
}

$@
