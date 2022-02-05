# Steps to Expose service using Nginx Ingress on KinD

1. `kind create cluster --config KinD/config.yaml` to start a cluster that support nginx.
2. `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml` to use the nginx ingress.
3. `kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s` to check whether it is ready or not.