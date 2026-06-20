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

## Self-hosted Langfuse UI

Set `langfuse.enabled=true` to install Langfuse inside the Heimdall cluster. The chart uses the official
`langfuse/langfuse` Helm chart and exposes the UI through `svc/langfuse-web` with `type=LoadBalancer`.

The bootstrap secret initializes one Heimdall organization, one project, one API key pair, and one admin user
on first startup.

```bash
helm dependency build charts/heimdall-aiops-stack
helm upgrade --install heimdall-aiops ./charts/heimdall-aiops-stack \
  --namespace heimdall --create-namespace \
  -f examples/team6-2-values.yaml \
  --set langfuse.bootstrap.publicKey="<langfuse-public-key>" \
  --set langfuse.bootstrap.secretKey="<langfuse-secret-key>" \
  --set langfuse.bootstrap.adminEmail="<admin-email>" \
  --set langfuse.bootstrap.adminPassword="<admin-password>" \
  --set langfuse.bootstrap.salt="$(openssl rand -base64 32)" \
  --set langfuse.bootstrap.encryptionKey="$(openssl rand -hex 32)" \
  --set langfuse.bootstrap.nextauthSecret="$(openssl rand -hex 32)" \
  --set langfuse.bootstrap.postgresPassword="$(openssl rand -hex 24)" \
  --set langfuse.bootstrap.redisPassword="$(openssl rand -hex 24)" \
  --set langfuse.bootstrap.clickhousePassword="$(openssl rand -hex 24)" \
  --set langfuse.bootstrap.minioRootPassword="$(openssl rand -hex 24)"
```

Get the UI endpoint:

```bash
kubectl get svc -n heimdall langfuse-web
```

For in-cluster Heimdall agent traffic, use the internal endpoint:

```text
http://langfuse-web.heimdall.svc.cluster.local
```

The initial project is:

- org: `heimdall`
- project: `heimdall-ai-workflow`

The default Langfuse dashboards provide trace volume, latency, cost, and model usage views. Heimdall traces
should be filtered by trace names/tags such as `heimdall.ai_workflow`, `incident_id`, `workflow_run_id`,
`rca_result_id`, and `verification_verdict`.

## Render Check

```bash
tests/render.sh
```
