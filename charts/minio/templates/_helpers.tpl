{{/*
Expand the name of the chart.
*/}}
{{- define "minio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "minio.fullname" -}}
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
{{- define "minio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "minio.labels" -}}
helm.sh/chart: {{ include "minio.chart" . }}
{{ include "minio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "minio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "minio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "minio.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "minio.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

## MINIO ACCESSKEY
{{/*
Define a function that generate static minio accessKey
*/}}
{{- define "generate_static_minio_accesskey" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars_minio_accesskey") -}}
{{-   $_ := set .Release "tmp_vars_minio_accesskey" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "minio_accesskey" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars_minio_accesskey $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars_minio_accesskey $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars_minio_accesskey $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_minio_accesskey_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace .Values.minio.clusterName).data -}}
    {{- if $data -}}
      {{- index $data .Values.minio.random_accesskey_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass .Values.minio.clusterName (the name of a secret to retrieve password from on upgrade)" .Values.minio.clusterName) (required "You must pass .Values.minio.random_accesskey_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.minio.random_accesskey_secret_key) -}}
      {{- (include "generate_static_minio_accesskey" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

## MINIO SECRETKEY
{{/*
Define a function that generate static minio secretKey
*/}}
{{- define "generate_static_minio_secretkey" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars_minio_secretkey") -}}
{{-   $_ := set .Release "tmp_vars_minio_secretkey" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "minio_secretkey" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars_minio_secretkey $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars_minio_secretkey $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars_minio_secretkey $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_minio_secretkey_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace .Values.minio.clusterName).data -}}
    {{- if $data -}}
      {{- index $data .Values.minio.random_secretkey_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass .Values.minio.clusterName (the name of a secret to retrieve password from on upgrade)" .Values.minio.clusterName) (required "You must pass .Values.minio.random_secretkey_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.minio.random_secretkey_secret_key) -}}
      {{- (include "generate_static_minio_secretkey" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}