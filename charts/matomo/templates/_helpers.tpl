{{/*
Expand the name of the chart.
*/}}
{{- define "matomo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "matomo.fullname" -}}
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
{{- define "matomo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "matomo.labels" -}}
helm.sh/chart: {{ include "matomo.chart" . }}
{{ include "matomo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "matomo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "matomo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "matomo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "matomo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

## MARIADB PASSWORD
{{/*
Define a function that generate static mariadb password
*/}}
{{- define "generate_static_mariadb_password" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars_mariadb") -}}
{{-   $_ := set .Release "tmp_vars_mariadb" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "mariadb_password" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars_mariadb $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars_mariadb $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars_mariadb $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_mariadb_pw_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace .Values.mariadb.name).data -}}
    {{- if $data -}}
      {{- index $data .Values.mariadb.random_pw_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass .Values.mariadb.name (the name of a secret to retrieve password from on upgrade)" .Values.mariadb.name) (required "You must pass .Values.mariadb.random_pw_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.mariadb.random_pw_secret_key) -}}
      {{- (include "generate_static_mariadb_password" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

## MARIADB ROOT PASSWORD
{{/*
Define a function that generate static mariadb root password
*/}}
{{- define "generate_static_mariadb_root_password" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars_mariadb_root") -}}
{{-   $_ := set .Release "tmp_vars_mariadb_root" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "mariadb_root_password" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars_mariadb_root $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars_mariadb_root $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars_mariadb_root $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_mariadb_root_pw_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace .Values.mariadb.name).data -}}
    {{- if $data -}}
      {{- index $data .Values.mariadb.random_root_pw_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass .Values.mariadb.name (the name of a secret to retrieve password from on upgrade)" .Values.mariadb.name) (required "You must pass .Values.mariadb.random_root_pw_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.mariadb.random_root_pw_secret_key) -}}
      {{- (include "generate_static_mariadb_root_password" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

## MATOMO PASSWORD
{{/*
Define a function that generate static matomo password
*/}}
{{- define "generate_static_matomo_password" -}}
{{- /* Create "tmp_vars" dict inside ".Release" to store various stuff. */ -}}
{{- if not (index .Release "tmp_vars_matomo") -}}
{{-   $_ := set .Release "tmp_vars_matomo" dict -}}
{{- end -}}
{{- /* Some random ID of this password, in case there will be other random values alongside this instance. */ -}}
{{- $key := printf "%s_%s" .Release.Name "matomo_password" -}}
{{- /* If $key does not yet exist in .Release.tmp_vars, then... */ -}}
{{- if not (index .Release.tmp_vars_matomo $key) -}}
{{- /* ... store random password under the $key */ -}}
{{-   $_ := set .Release.tmp_vars_matomo $key (randAlphaNum 20) -}}
{{- end -}}
{{- /* Retrieve previously generated value. */ -}}
{{- index .Release.tmp_vars_matomo $key -}}
{{- end -}}

{{/*
Define a function that lookup the secret on upgrade. If install, it requires the name of secret to create and the key to store the password.
*/}}
{{- define "random_matomo_pw_reusable" -}}
  {{- if .Release.IsUpgrade -}}
    {{- $data := default dict (lookup "v1" "Secret" .Release.Namespace .Values.matomo.name).data -}}
    {{- if $data -}}
      {{- index $data .Values.matomo.random_pw_secret_key | b64dec -}}
    {{- end -}}
  {{- else -}}
    {{- if and (required "You must pass .Values.matomo.name (the name of a secret to retrieve password from on upgrade)" .Values.matomo.name) (required "You must pass .Values.matomo.random_pw_secret_key (the name of the key in the secret to retrieve password from on upgrade)" .Values.matomo.random_pw_secret_key) -}}
      {{- (include "generate_static_matomo_password" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
