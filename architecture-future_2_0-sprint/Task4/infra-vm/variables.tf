variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID каталога"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  default     = "ru-central1-a"
  type        = string
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "ssh_public_key" {
  default = "~/.ssh/yc/id_rsa_terraform.pub"
}

variable "ssh_private_key" {
  default = "~/.ssh/yc/id_rsa_terraform"
}
