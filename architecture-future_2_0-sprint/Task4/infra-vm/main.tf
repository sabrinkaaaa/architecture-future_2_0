terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.99"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  service_account_key_file = "key.json"
}

resource "yandex_vpc_network" "default" {
  name = "future-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "future-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "future-vm" {
  name = "future-vm"
  zone = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}"
  }
}

resource "null_resource" "install-k3s" {
  depends_on = [yandex_compute_instance.future-vm]

  provisioner "file" {
    source      = "install-k3s.sh"
    destination = "/home/ubuntu/install_k3s.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = yandex_compute_instance.future-vm.network_interface[0].nat_ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_k3s.sh",
      "/home/ubuntu/install_k3s.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = yandex_compute_instance.future-vm.network_interface[0].nat_ip_address
    }
  }

  triggers = {
    host = yandex_compute_instance.future-vm.network_interface[0].nat_ip_address
  }
}

output "kubeconfig" {
  value = <<EOF
    scp -i ${var.ssh_private_key} ubuntu@${yandex_compute_instance.future-vm.network_interface[0].nat_ip_address}:/home/ubuntu/k3s.yaml ./k3s.yaml
    sed -i 's/127.0.0.1/${yandex_compute_instance.future-vm.network_interface[0].nat_ip_address}/g' k3s.yaml
  EOF
}
