{{- define "goapp.name" -}}
goapp
{{- end -}}

{{- define "goapp.fullname" -}}
{{ include "goapp.name" . }}
{{- end -}}
