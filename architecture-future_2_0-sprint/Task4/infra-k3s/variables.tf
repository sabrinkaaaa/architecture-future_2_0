variable "kubeconfig" {
  default = "../infra-vm/k3s.yaml"
}

variable "image" {
  default = "ghcr.io/breadrock1/architecture-future_2_0/go-app:sha-7e89814"
}

variable "extra_env" {
  type = map(string)
  default = {
    DB_CONNECTION_STRING  = "postgres://postgres:postgres@postgres-postgresql.future-2-0.svc.cluster.local/postgres?sslmode=disable"
  }
}
