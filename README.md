# KubeWorkz-Chart

KubeWorkz-Chart is a helm chart for KubeWorkz. This version totally matches the KubeWorkz version. The `appVersion` of Chart.yaml will pin to a specifield KubeWorkz version.

## Prerequisites

- Kubernetes 1.16+
- helm v3+

## Get the Chart

To install the chart with the release name `kubeworkz` or `warden` in namespace `kubeworkz-system`:

- download to local

```console
git clone https://github.com/saashqdev/kubeworkz-chart.git
```

## Install pivot cluster

Create `pivot-value.yaml` and set values as you wish.

```yaml
# pivot-value.yaml

global:
  # control-plane node IP which is used for exporting NodePort svc.
  nodeIP: x.x.x.x
  
  # set "true" to deploy if there were not already in cluster.
  dependencesEnable:  
    ingressController: "false"
    localPathStorage: "false"
    metricServer: "false"

  # set "enabled" if you want to open log application.
  hotPlugEnable:
    pivot:
      logseer: "disabled" 
      logagent: "disabled"
      elasticsearch: "disabled"

  localKubeConfig: xx # local cluster kubeconfig base64
  pivotKubeConfig: xx # pivot cluster kubeconfig base64

warden:
  containers:
    warden:
      args:
        cluster: "pivot-cluster"  # set current cluster name
```

```console
helm install kubeworkz -n kubeworkz-system --create-namespace ./kubeworkz-chart -f ./pivot-value.yaml
```

## Install member cluster

Create `member-value.yaml` and set values as you wish.

```yaml
# member-value.yaml

global:
  # control-plane node IP which is used for exporting NodePort svc.
  nodeIP: x.x.x.x
  
  # set "true" to deploy if there were not already in cluster.
  dependencesEnable: 
    ingressController: "false"
    localPathStorage: "false"
    metricServer: "false"
    
  # do not modify values as below.
  componentsEnable:
    kubeworkz: "false"
    warden: "true"
    audit: "false"
    webconsole: "false"
    cloudshell: "false"
    frontend: "false"
    
  # set "enabled" if you want to open log application.
  hotPlugEnable:
    common:
      logagent: "disabled"

  localKubeConfig: xx # local cluster kubeconfig base64
  pivotKubeConfig: xx # pivot cluster kubeconfig base64

warden:
  containers:
    warden:
      args:
        inMemberCluster: true
        cluster: "member-cluster"  # set current cluster name
```

```console
helm install warden -n kubeworkz-system --create-namespace ./kubeworkz-chart -f ./member-value.yaml
```

## Uninstalling the Chart
> **Note**: not found error can be ignored. 

### Before helm uninstall

```console
kubectl delete validatingwebhookconfigurations kubeworkz-validating-webhook-configuration warden-validating-webhook-configuration kubeworkz-monitoring-admission
```

To uninstall/delete the `kubeworkz` helm release in namespace `kubeworkz-system`:


### Uninstall KubeWorkz in control plane
```console
helm uninstall kubeworkz -n kubeworkz-system
```

### Uninstall Warden in member cluster
```console
helm uninstall warden -n kubeworkz-system
```

### After helm uninstall

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Note**: There are some RBAC resources that are used by the `preJob` that can not be deleted by the `uninstall` command above. You might have to clean them manually with tools like `kubectl`.  You can clean them by commands:

```console
kubectl delete sa/kubeworkz-pre-job -n kubeworkz-system
kubectl delete clusterRole/kubeworkz-pre-job 
kubectl delete clusterRoleBinding/kubeworkz-pre-job
kubectl delete ns kubeworkz-system hnc-system kubeworkz-monitoring
```
