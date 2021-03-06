{{/* vim: set filetype=mustache: */}}

{{/*Expand the name of the chart.*/}}
{{- define "pomerium.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the proxy-service.*/}}
{{- define "pomerium.proxy.name" -}}
{{- default (printf "%s-proxy" .Chart.Name) .Values.proxy.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the authenticate-service.*/}}
{{- define "pomerium.authenticate.name" -}}
{{- default (printf "%s-authenticate" .Chart.Name) .Values.authenticate.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the authorize-service.*/}}
{{- define "pomerium.authorize.name" -}}
{{- default (printf "%s-authorize" .Chart.Name) .Values.authorize.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the cache-service.*/}}
{{- define "pomerium.cache.name" -}}
{{- default (printf "%s-cache" .Chart.Name) .Values.cache.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the operator .*/}}
{{- define "pomerium.operator.name" -}}
{{- default (printf "%s-operator" .Chart.Name) .Values.operator.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pomerium.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Proxy services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.proxy.fullname" -}}
{{- if .Values.proxy.fullnameOverride -}}
{{- .Values.proxy.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-proxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-proxy" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* authorize services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.authorize.fullname" -}}
{{- if .Values.authorize.fullnameOverride -}}
{{- .Values.authorize.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authorize" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authorize" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* cache services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.cache.fullname" -}}
{{- if .Values.cache.fullnameOverride -}}
{{- .Values.cache.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-cache" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-cache" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* authenticate services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.authenticate.fullname" -}}
{{- if .Values.authenticate.fullnameOverride -}}
{{- .Values.authenticate.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authenticate" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authenticate" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* operator fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.operator.fullname" -}}
{{- if .Values.operator.fullnameOverride -}}
{{- .Values.operator.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-operator" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-operator" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*Create chart name and version as used by the chart label.*/}}
{{- define "pomerium.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pomerium.routestring" -}}
{{- $routes := dict "routes" (list) -}}
{{- range $key, $val := .Values.proxy.routes -}}
{{- $noop := printf "%s=%s" $key $val | append $routes.routes | set $routes "routes" -}}
{{- end -}}
{{- join "," $routes.routes | default "none=none" | quote -}}
{{- end -}}


{{/*
Check if a valid identity provider has been set
Adapted from : https://github.com/helm/charts/blob/master/stable/drone/templates/_provider-envs.yaml
*/}}
{{- define "pomerium.providerOK" -}}
{{- if .Values.authenticate.idp -}}
  {{- if .Values.config.existingSecret -}}
  true
  {{- else if eq .Values.authenticate.idp.clientID "" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientSecret "" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientID "REPLACE_ME" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientSecret "REPLACE_ME" -}}
  false
  {{- else -}}
  true
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Authenticate TLS Cert */}}
{{- define "pomerium.authenticate.tlsSecret.name" -}}
{{- if .Values.authenticate.existingTLSSecret -}}
{{- .Values.authenticate.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authenticate-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authenticate-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Authorize TLS Cert */}}
{{- define "pomerium.authorize.tlsSecret.name" -}}
{{- if .Values.authorize.existingTLSSecret -}}
{{- .Values.authorize.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authorize-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authorize-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for cache TLS Cert */}}
{{- define "pomerium.cache.tlsSecret.name" -}}
{{- if .Values.cache.existingTLSSecret -}}
{{- .Values.cache.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-cache-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-cache-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Proxy TLS Cert */}}
{{- define "pomerium.proxy.tlsSecret.name" -}}
{{- if .Values.proxy.existingTLSSecret -}}
{{- .Values.proxy.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-proxy-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-proxy-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "pomerium.caSecret.name" -}}
{{if .Values.config.existingCASecret }}
{{- .Values.config.existingCASecret | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-ca-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ca-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*Expand the FQDN of the forward-auth endpoint.*/}}
{{- define "pomerium.forwardAuth.name" -}}
{{- default (printf "forwardauth.%s" .Values.config.rootDomain ) .Values.forwardAuth.nameOverride -}}
{{- end -}}

{{/*Expand the serviceAccountName for the operator */}}
{{- define "pomerium.operator.serviceAccountName" -}}
{{- default (printf "%s-operator" ( include "pomerium.fullname" .) ) .Values.forwardAuth.nameOverride -}}
{{- end -}}

{{/*Expand the configMap for operator election */}}
{{- define "pomerium.operator.electionConfigMap" -}}
{{- printf "%s-election" ( include "pomerium.operator.name" .) -}}
{{- end -}}