output "hosts" {
  value = keys(libvirt_domain.domain)
}

output "ip" {
  value = values(libvirt_domain.domain)[*].network_interface.0.addresses.0
}
