terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}


provider "libvirt" {
  uri = "qemu:///system"
}


resource "libvirt_volume" "centos-7" {
  name   = "centos-7"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
}


resource "libvirt_volume" "volume" {
  for_each       = toset(var.hosts)
  name           = "volume-${each.value}"
  base_volume_id = libvirt_volume.centos-7.id
  pool           = "default"
  size           = 53687091200
}


data "template_file" "user_data" {
  for_each = toset(var.hosts)
  template = file("${path.module}/templates/cloud-config.yml.tpl")
  vars = {
    hostname = each.value
  }
}


resource "libvirt_cloudinit_disk" "commoninit" {
  for_each  = toset(var.hosts)
  name      = "commoninit-${each.value}"
  user_data = data.template_file.user_data[each.value].rendered
}


resource "libvirt_domain" "domain" {
  for_each = toset(var.hosts)
  name     = each.value
  memory   = "4096"
  vcpu     = 4

  network_interface {
    hostname       = each.value
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.volume[each.value].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[each.value].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      hosts = libvirt_domain.domain
    }
  )
  filename = "../ansible/inventory"
}
