{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "notebook-config" -}}
# Configuration file for ipython-notebook.

c = get_config()

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '127.0.0.1'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.base_url = '/'
c.NotebookApp.trust_xheaders = True
c.NotebookApp.tornado_settings = {'static_url_prefix': '/static/'}
{{ if ne .Values.persistentStorage.existingClaim "" }}
c.NotebookApp.notebook_dir = '/mnt/{{ .Values.persistentStorage.existingClaimName }}'
{{ else }}
c.NotebookApp.notebook_dir = '/notebooks'
{{ end }}
{{ if ne .Values.githubToken "" }}
c.GitHubConfig.access_token = '{{ .Values.githubToken }}'
{{ end }}
c.NotebookApp.allow_origin = '*'
c.NotebookApp.token = ''
c.NotebookApp.password = ''

{{- end -}}
