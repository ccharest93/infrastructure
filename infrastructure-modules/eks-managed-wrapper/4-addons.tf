# resource "helm_release" "argocd" {

#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   namespace  = "argocd"
#   version    = "3.35.4"
#   create_namespace =  true

#   values = [file("values/argocd.yaml")]
# }

# resource "helm_release" "kube-prometheus-stack" {

#   name       = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   namespace  = "monitoring"
#   version    = "52.1.0"
#   create_namespace =  true
#   depends_on = [module.eks]
#   # lifecycle {
#   #   replace_triggered_by = [
#   #     helm_release.kube-prometheus-stack, //Replace `azurerm_app_service` each time `azurerm_sql_database` id changes
#   #   ]
#   # }
#   values = [file("values/kube-prometheus-stack.yaml")]
# }

# resource "helm_release" "gpu-operator" {
#   name       = "gpu-operator"
#   repository = "https://helm.ngc.nvidia.com/nvidia"
#   chart      = "gpu-operator"
#   version    = "v23.9.0"
#   namespace  = "gpu-operator"
#   create_namespace =  true
#   #values = [file("values/gpu-operator.yaml")]
#   #   lifecycle {
#   #   replace_triggered_by = [
#   #     helm_release.gpu-operator, //Replace `azurerm_app_service` each time `azurerm_sql_database` id changes
#   #   ]
#   # }
#   depends_on = [module.eks]
# } 