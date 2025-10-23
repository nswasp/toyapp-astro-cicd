{{- define "chart.basename" -}}
{{ .Values.app.name }}
{{- end -}}

{{- define "chart.fullname" -}}
{{- $base := include "chart.basename" . -}}
{{- printf "%s-%s" $base .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chart.parseEnv" -}}
{{- $envStr := .Values.envVars | default "" -}}
{{- if $envStr }}
{{- $pairs := splitList "\n" $envStr -}}
{{- range $i, $kv := $pairs -}}
  {{- $kv := trim $kv "\r" -}}
  {{- if ne $kv "" -}}
    {{- $parts := split "=" $kv -}}
    - name: {{ index $parts 0 | trim }}
      value: {{ index $parts 1 | default "" | quote }}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
