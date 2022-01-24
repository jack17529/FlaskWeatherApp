# About Cluster

1. export your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
2. `export KUBECONFIG=$PWD/kubeconfig.yaml` to export your kubeconfig.yaml here.
3. `eksctl create cluster -f cluster-1.21.yaml` to set up a cluster on eks.
4. `eksctl delete cluster -f cluster-1.21.yaml` to delete the cluster.

# Helm

- `helm install app-chart app-chart` to install the chart.