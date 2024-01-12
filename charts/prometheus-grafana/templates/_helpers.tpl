{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-grafana.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prometheus-grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "prometheus-grafana.labels" -}}
helm.sh/chart: {{ include "prometheus-grafana.chart" . }}
{{ include "prometheus-grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prometheus-grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prometheus-grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus-grafana.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "prometheus-grafana.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* 
Generate prometheus secret password
*/}}
{{- define "prometheus.secretPassword" -}}
pass: {{ randAlphaNum 16 | quote }}
{{- end }}

{{/* 
Generate grafana secret password
*/}}
{{- define "grafana.secretPassword" -}}
admin-password: {{ randAlphaNum 16 | quote }}
{{- end }}

# {{/*
# Generate prometheus static password for multiple use
# */}}
# {{- define "prometheus.staticPassword" -}}
# {{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
# {{- if not (index .Release "tmp_vars") -}}
# {{-   $_ := set .Release "tmp_vars" dict -}}
# {{- end -}}
# {{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
# {{- $key := printf "%s_%s" .Release.Name "password" -}}
# {{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
# {{- if not (index .Release.tmp_vars $key) -}}
# {{- /* ... store random password under the $key */ -}}
# {{-   $_ := set .Release.tmp_vars $key (randAlphaNum 16 | quote ) -}}
# {{- end -}}
# {{- /* Retrieve previously generated value. */ -}}
# {{- index .Release.tmp_vars $key -}}
# {{- end -}}