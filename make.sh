NAMESPACE=staging-1-3

function create-secrets(){
    kubectl create secret generic db-user-pass  --from-file=./private/password.txt
    kubectl create secret generic odatests-tests-bot-password  --from-file=./private/testbot-password.txt
    kubectl create secret generic odatests-secret-key  --from-file=./private/secret-key.txt
    kubectl create secret generic minio-key  --from-file=./private/minio-key.txt
    kubectl create secret generic jena-password  --from-file=./private/jena-password.txt
    kubectl create secret generic logstash-entrypoint  --from-file=./private/logstash-entrypoint.txt
}

function install() {
    set -x
    helm -n ${NAMESPACE:?} install  oda-dqueue . --set image.tag="$(cd dqueue; git describe --always)"
}

function upgrade() {
    set -x
    helm upgrade -n ${NAMESPACE:?} oda-dqueue . --set image.tag="$(cd dqueue; git describe --always)"
}

$@
