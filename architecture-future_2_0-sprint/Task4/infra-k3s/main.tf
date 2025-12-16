resource "kubernetes_namespace" "ns" {
  metadata {
    name = "future-2-0"
  }
}

resource "helm_release" "postgres" {
  name       = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = kubernetes_namespace.ns.metadata[0].name
  chart      = "postgresql"
  version    = "18.1.9"

  values = [
    yamlencode({
      auth = {
        username = "postgres"
        password = "postgres"
        database = "postgres"
      }
      primary = {
        persistence = { enabled = false }
      }
    })
  ]
}

resource "helm_release" "goapp" {
  name       = "go-app"
  chart      = "charts/go-app"
  namespace  = kubernetes_namespace.ns.metadata[0].name

  values = [
    templatefile("${path.module}/charts/go-app/values.tpl.yaml", {
      image     = var.image
      extra_env = var.extra_env
    })
  ]

  depends_on = [helm_release.postgres]
}
