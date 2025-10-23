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
  {{- $kv := trim $kv -}}
  {{- if and (ne $kv "") (contains $kv "=") -}}
    {{- $parts := split "=" $kv -}}
    {{- $name := index $parts 0 | trim }}
    {{- $value := (slice $parts 1 | join "=") | trim }}
    - name: {{ $name }}
      value: {{ $value | quote }}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
