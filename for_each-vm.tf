# Создание ВМ с использованием for_each
resource "yandex_compute_instance" "db" {
  for_each      = { for vm in var.vm_db_config : vm.name => vm }
  name          = each.value.name
  hostname      = each.value.name
  platform_id   = each.value.platform_id
  zone          = each.value.zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id  = data.yandex_compute_image.ubuntu.image_id # Ubuntu 20.04 LTS
      size      = each.value.disk_size
      type      = each.value.hdd_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat_ip
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${local.ssh_public_key}" # Используем SSH-ключ
  }
}