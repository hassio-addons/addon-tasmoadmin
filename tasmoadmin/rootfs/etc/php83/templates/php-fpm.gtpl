[{{ .name }}]
{{ if .base }}
env[TASMO_BASEURL] = '{{ .base }}'
{{ end }}
