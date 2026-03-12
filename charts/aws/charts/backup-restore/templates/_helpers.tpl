{{- define "liferay-aws-backup-restore.artifactRepositoryConfigMapName" -}}
{{- printf "%s-art-repo" (include "liferay-aws-backup-restore.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "liferay-aws-backup-restore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "liferay-aws-backup-restore.fullname" -}}
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

{{- define "liferay-aws-backup-restore.gitCredentials.externalSecretName" -}}
{{- printf "%s-git-creds" (include "liferay-aws-backup-restore.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "liferay-aws-backup-restore.gitCredentials.volumeMount" -}}
volumeMounts:
    -   mountPath: /mnt/.git-credentials
        name: git-credentials
        subPath: .git-credentials
{{- end -}}

{{- define "liferay-aws-backup-restore.infraResourceBaseName" -}}
{{- $projectIdFull := printf "%s-%s" .Values.global.projectId .Values.global.environmentId -}}
{{- $uidHash := printf "%s-%s-%s" .Values.global.aws.accountId .Values.global.deploymentName $projectIdFull | sha256sum | trunc 6 -}}
{{- printf "%.18s-%s" $projectIdFull $uidHash -}}
{{- end -}}

{{- define "liferay-aws-backup-restore.labels" -}}
{{ include "liferay-aws-backup-restore.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "liferay-aws-backup-restore.chart" . }}
{{- end -}}

{{- define "liferay-aws-backup-restore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "liferay-aws-backup-restore.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "liferay-aws-backup-restore.name" . }}
{{- end -}}