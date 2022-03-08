echo "${ODA_NAMESPACE:=staging-1-3}"

DQUEUE_IMAGE_TAG=${DQUEUE_IMAGE_TAG:-"$(cd dqueue; git describe --always)"}

function create-secrets(){
    kubectl create secret -n $ODA_NAMESPACE generic db-user-pass  --from-file=./private/password.txt
    kubectl create secret -n $ODA_NAMESPACE generic odatests-tests-bot-password  --from-file=./private/testbot-password.txt
    kubectl create secret -n $ODA_NAMESPACE generic odatests-secret-key  --from-file=./private/secret-key.txt

    kubectl delete secret -n $ODA_NAMESPACE minio-key
    kubectl create secret -n $ODA_NAMESPACE generic minio-key  --from-file=./private/minio-key.txt 

    kubectl create secret -n $ODA_NAMESPACE generic jena-password  --from-file=./private/jena-password.txt
    kubectl create secret -n $ODA_NAMESPACE generic logstash-entrypoint  --from-file=./private/logstash-entrypoint.txt
    kubectl create secret -n $ODA_NAMESPACE generic gateway-secret  --from-file=gateway-secret.txt=$HOME/gateway-secret-hexified

    kubectl delete secret -n $ODA_NAMESPACE dda-token
    kubectl create secret -n $ODA_NAMESPACE generic dda-token  --from-file=dda-token=$HOME/.dda-token
}

function install() {
    set -x
    upgrade
}

function upgrade() {
    set -x
    helm upgrade --install -n ${ODA_NAMESPACE:?} oda-dqueue . -f values-${ODA_SITE}.yaml --set image.tag=$DQUEUE_IMAGE_TAG
}

$@
