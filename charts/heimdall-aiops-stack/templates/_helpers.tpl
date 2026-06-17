{{- define "heimdall-aiops-stack.name" -}}
heimdall-aiops-stack
{{- end -}}

{{- define "heimdall-aiops-stack.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

{{- define "heimdall-aiops-stack.labels" -}}
app.kubernetes.io/part-of: heimdall
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "heimdall-aiops-stack.image" -}}
{{- $registry := .registry -}}
{{- $repository := .repository -}}
{{- $tag := .tag -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{- define "heimdall-aiops-stack.imagePullSecrets" -}}
{{- if .Values.imagePullSecrets }}
imagePullSecrets:
{{- toYaml .Values.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end -}}
