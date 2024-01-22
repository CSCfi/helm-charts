{{/*
Expand the name of the chart.
*/}}
{{- define "rocket-chat.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "rocketchat.mongodb.fullname" -}}
{{- printf "%s-%s-headless" .Release.Name "mongodb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rocket-chat.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rocket-chat.labels" -}}
helm.sh/chart: {{ include "rocket-chat.chart" . }}
{{ include "rocket-chat.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rocket-chat.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rocket-chat.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rocket-chat.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rocket-chat.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*Generate the MONGO_URL*/}}
{{- define "rocketchat.mongodb.url" }}
    {{- $service := .Values.mongodb.appName }}
    {{- $user := required "usernames array must have at least one entry" (.Values.mongodb.dbUser) }}
    {{- $password := required "passwords array must have at least one entry" (.Values.mongodb.password) }}
    {{- $database := required "databases array must have at least one entry" (.Values.mongodb.dbName) }}
    {{- $port := .Values.mongodb.service.ports.mongodb }}
    {{- printf "mongodb://%s:%s@%s:%0.f/%s" $user $password $service $port $database }}
{{- end }}
