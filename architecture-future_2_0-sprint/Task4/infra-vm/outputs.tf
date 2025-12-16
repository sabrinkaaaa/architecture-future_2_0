output "external_ip" {
  description = "Публичный IP адрес ВМ"
  value       = yandex_compute_instance.future-vm.network_interface[0].nat_ip_address
}

output "vm_public_ip" {
  value = yandex_compute_instance.future-vm.network_interface[0].nat_ip_address
}
