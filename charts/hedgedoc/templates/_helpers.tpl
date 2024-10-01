{{/*
Expand the name of the chart.
*/}}
{{- define "hedgedoc-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hedgedoc-helm.fullname" -}}
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
{{- define "hedgedoc-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hedgedoc-helm.labels" -}}
helm.sh/chart: {{ include "hedgedoc-helm.chart" . }}
{{ include "hedgedoc-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hedgedoc-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hedgedoc-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hedgedoc-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hedgedoc-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define a function that generate static password
*/}}
{{- define "generate_static_password" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars") -}}
{{-   $_ := set .Release "tmp_vars" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "password" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_pw_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace "postgres").data -}}
    {{- if $data -}}
      {{- index $data .Values.hedgedoc.random_pw_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass postgres (the name of a secret to retrieve password from on upgrade)" "postgres") (required "You must pass .Values.hedgedoc.random_pw_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.hedgedoc.random_pw_secret_key) -}}
      {{- (include "generate_static_password" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Return PostgreSQL auth database name
NOTE: This macro is run in both the parent chart and the PostgreSQL
subchart (as it is used in the init scripts), so we need to control the
scope
*/}}
{{- define "hedgedoc.v0.database-auth.name" -}}
{{- if .Values.postgresql -}}
    {{/* Inside parent chart */}}
    {{- if .Values.postgresql.enabled -}}
    {{- printf "%s_auth" .Values.postgresql.auth.database -}}
    {{- end -}}
{{- else -}}
    {{/* Inside postgresql sub-chart, therefore postgresql.enabled=true */}}
    {{- printf "%s_auth" .Values.auth.database -}}
{{- end -}}
{{- end -}}