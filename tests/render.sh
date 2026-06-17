#!/usr/bin/env sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
VALUES_FILE="/tmp/heimdall-aiops-stack-test-values.yaml"

cat >"$VALUES_FILE" <<'YAML'
secrets:
  alertWebhookToken: redacted-alert-token
  readGatewayToken: redacted-read-token
  awsAccessKeyId: redacted-access-key
  awsSecretAccessKey: redacted-secret-key
telemetryQueryGateway:
  connectionsJson: >-
    [{"cluster_id":"clu_otel001","connection_id":"tel_otel_demo","base_url":"http://example.local","token_env":"OTEL_DEMO_READ_TOKEN"}]
YAML

helm lint "$ROOT_DIR/charts/heimdall-aiops-stack" -f "$VALUES_FILE"
helm template heimdall-aiops "$ROOT_DIR/charts/heimdall-aiops-stack" \
  --namespace heimdall \
  -f "$VALUES_FILE" \
  >/tmp/heimdall-aiops-stack-rendered.yaml

grep -q "kind: Deployment" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-backend" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-alert-ingest" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-telemetry-query-gateway" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-incident-manager" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-resource-collector" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "name: heimdall-operation-mcp" /tmp/heimdall-aiops-stack-rendered.yaml
grep -q "amdp-registry.skala-ai.com" /tmp/heimdall-aiops-stack-rendered.yaml
