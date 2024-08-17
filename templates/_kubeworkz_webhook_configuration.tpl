{{- define "kubeworkz.webhook.configuration" -}}
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  creationTimestamp: null
  name: kubeworkz-validating-webhook-configuration
webhooks:
  - admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      {{- include "kubeworkz.webhook.caBundle" . | nindent 6 }}
      service:
        name: kubeworkz
        namespace: {{ template "kubeworkz.namespace" . }}
        port: {{ .Values.kubeworkz.args.webhookServerPort }}
        path: /validate-quota-kubeworkz-io-v1-kube-resource-quota
    failurePolicy: Fail
    name: vkuberesourcequota.kb.io
    rules:
      - apiGroups:
          - quota.kubeworkz.io
        apiVersions:
          - v1
        operations:
          - CREATE
          - UPDATE
          - DELETE
        resources:
          - kuberesourcequota
    sideEffects: None
  - admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      {{- include "kubeworkz.webhook.caBundle" . | nindent 6 }}
      service:
        name: kubeworkz
        namespace: {{ template "kubeworkz.namespace" . }}
        port: {{ .Values.kubeworkz.args.webhookServerPort }}
        path: /validate-hotplug-kubeworkz-io-v1-hotplug
    failurePolicy: Fail
    name: vhotplug.kb.io
    rules:
      - apiGroups:
          - hotplug.kubeworkz.io
        apiVersions:
          - v1
        operations:
          - CREATE
          - UPDATE
          - DELETE
        resources:
          - hotplugs
    sideEffects: None
  - admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      {{- include "kubeworkz.webhook.caBundle" . | nindent 6 }}
      service:
        name: kubeworkz
        namespace: {{ template "kubeworkz.namespace" . }}
        port: {{ .Values.kubeworkz.args.webhookServerPort }}
        path: /validate-cluster-kubeworkz-io-v1-cluster
    failurePolicy: Ignore
    name: vcluster.kb.io
    rules:
      - apiGroups:
          - cluster.kubeworkz.io
        apiVersions:
          - v1
        operations:
          - CREATE
          - UPDATE
        resources:
          - clusters
    sideEffects: None
    timeoutSeconds: 1
  - admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      {{- include "kubeworkz.webhook.caBundle" . | nindent 6 }}
      service:
        name: kubeworkz
        namespace: kubeworkz-system
        port: 9443
        path: /validate-tenant-kubeworkz-io-v1-project
    failurePolicy: Fail
    name: vproject.kb.io
    rules:
      - apiGroups:
          - tenant.kubeworkz.io
        apiVersions:
          - v1
        operations:
          - CREATE
          - UPDATE
          - DELETE
        resources:
          - projects
    sideEffects: None
  - admissionReviewVersions:
      - v1
      - v1beta1
    clientConfig:
      {{- include "kubeworkz.webhook.caBundle" . | nindent 6 }}
      service:
        name: kubeworkz
        namespace: kubeworkz-system
        port: 9443
        path: /validate-tenant-kubeworkz-io-v1-tenant
    failurePolicy: Fail
    name: vtenant.kb.io
    rules:
      - apiGroups:
          - tenant.kubeworkz.io
        apiVersions:
          - v1
        operations:
          - DELETE
        resources:
          - tenants
    sideEffects: None
---
{{- end -}}