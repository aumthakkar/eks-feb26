resource "kubernetes_manifest" "secret_provider_class_manifest" {
  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind = "SecretProviderClass"

    metadata = {
      name = "db-secrets"
    }

    spec = {
      provider = "aws"

      parameters = {
        usePodIdentity = "true"
        
        objects = <<-EOT
          - objectName: "db-secret-1"
            objectType: "secretManager"
            jmesPath: 
              - path : "MYSQL_USER"
                objectAlias: "MYSQL_USER"
              - path: "MYSQL_PASSWORD"
                objectAlias: "MYSQL_PASSWORD"

        EOT
      }
    }
  }
}