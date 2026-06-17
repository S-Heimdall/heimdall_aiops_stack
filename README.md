# Heimdall AIOps Stack

Helm chart for installing the Heimdall AIOps control-plane services into an EKS cluster.

## Install

```bash
helm upgrade --install heimdall-aiops ./charts/heimdall-aiops-stack \
  --namespace heimdall --create-namespace \
  --set secrets.alertWebhookToken="<alertmanager-webhook-token>" \
  --set secrets.readGatewayToken="<service-single-gateway-read-token>" \
  --set secrets.awsAccessKeyId="<aws-access-key-id>" \
  --set secrets.awsSecretAccessKey="<aws-secret-access-key>" \
  --set harborRegistrySecret.create=true \
  --set harborRegistrySecret.username="<harbor-username>" \
  --set harborRegistrySecret.password="<harbor-password>" \
  --set backend.env.AIOPS_ALERT_INGEST_URL="http://heimdall-alert-ingest-nlb.heimdall.svc.cluster.local:8000"
```

The default images use Harbor under `amdp-registry.skala-ai.com`. Override `global.imageRegistry`
or each component image repository/tag from values when publishing new images.

`frontend.enabled` defaults to `false` until a published Harbor frontend image is available.

## Helm Repository

After merging to `main`, GitHub Actions packages the chart and publishes `gh-pages`.

```bash
helm repo add heimdall-aiops https://s-heimdall.github.io/heimdall_aiops_stack
helm repo update
helm upgrade --install heimdall-aiops heimdall-aiops/heimdall-aiops-stack \
  --namespace heimdall --create-namespace \
  -f examples/team6-2-values.yaml
```

## Render Check

```bash
tests/render.sh
```
