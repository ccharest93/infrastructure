resource "kubectl_manifest" "efs_input_sc" {
    yaml_body = <<YAML
  apiVersion: v1 
  kind: StorageClass
  apiVersion: storage.k8s.io/v1
  metadata:
    name: efs-input-sc
  provisioner: efs.csi.aws.com
  parameters:
    provisioningMode: efs-ap
    fileSystemId: ${var.efs_model_input_id}
    directoryPerms: "700"
  YAML
}

resource "kubectl_manifest" "efs_input_pv" {
    yaml_body = <<YAML
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: efs-input-pv
  spec:
    capacity:
      storage: 20Gi
    volumeMode: Filesystem
    accessModes:
      - ReadWriteMany
    persistentVolumeReclaimPolicy: Retain
    storageClassName: efs-input-sc
    csi:
      driver: efs.csi.aws.com
      volumeHandle: ${var.efs_model_input_id}
YAML
depends_on = [kubectl_manifest.efs_input_sc]
}

resource "kubectl_manifest" "efs_input_pvc" {
  lifecycle {
    replace_triggered_by = [
      kubectl_manifest.efs_input_pv
    ]
  }
    yaml_body = <<YAML
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: efs-input-pvc
  spec:
    accessModes:
      - ReadWriteMany
    storageClassName: efs-input-sc
    volumeName: efs-input-pv
    resources:
      requests:
        storage: 20Gi
YAML
depends_on = [kubectl_manifest.efs_input_pv]
}

resource "kubectl_manifest" "efs_output_sc" {
    yaml_body = <<YAML
  apiVersion: v1 
  kind: StorageClass
  apiVersion: storage.k8s.io/v1
  metadata:
    name: efs-output-sc
  provisioner: efs.csi.aws.com
  parameters:
    provisioningMode: efs-ap
    fileSystemId: ${var.efs_model_output_id}
    directoryPerms: "700"
  YAML
}

resource "kubectl_manifest" "efs_output_pv" {
    yaml_body = <<YAML
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: efs-output-pv
  spec:
    capacity:
      storage: 20Gi
    volumeMode: Filesystem
    accessModes:
      - ReadWriteMany
    persistentVolumeReclaimPolicy: Retain
    storageClassName: efs-output-sc
    csi:
      driver: efs.csi.aws.com
      volumeHandle: ${var.efs_model_output_id}
YAML
depends_on = [kubectl_manifest.efs_output_sc]
}

resource "kubectl_manifest" "efs_output_pvc" {
  lifecycle {
    replace_triggered_by = [
      kubectl_manifest.efs_output_pv
    ]
  }
    yaml_body = <<YAML
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: efs-output-pvc
  spec:
    accessModes:
      - ReadWriteMany
    storageClassName: efs-output-sc
    volumeName: efs-output-pv
    resources:
      requests:
        storage: 20Gi
YAML
depends_on = [kubectl_manifest.efs_output_pv]
}
