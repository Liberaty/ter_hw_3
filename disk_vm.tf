resource "yandex_compute_disk" "disks" {
  count       = 3
  name        = "disk-${count.index + 1}" # Названия: disk-1, disk-2, disk-3
  zone        = "ru-central1-a"
  size        = 1                         # Размер диска в ГБ
  type        = "network-hdd"             # Тип диска
}

resource "yandex_compute_instance" "storage" {
  count        = 1
  name         = var.vm_storage_config[count.index].name
  hostname     = var.vm_storage_config[count.index].name            # чтобы автоматом создался fqdn в зоне ru-central1-a
  platform_id  = var.vm_storage_config[count.index].platform_id
  zone         = var.vm_storage_config[count.index].zone            # ru-central1-a

  resources {
    cores         = var.vm_storage_config[count.index].cores
    memory        = var.vm_storage_config[count.index].memory
    core_fraction = var.vm_storage_config[count.index].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id      # Ubuntu 20.04 LTS
      size     = var.vm_storage_config[count.index].hdd_size    # Размер системного диска в ГБ
      type     = var.vm_storage_config[count.index].hdd_type    # Тип диска
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_storage_config[count.index].nat_ip
  }
 
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks # Перебираем созданные диски
    content {
      disk_id = secondary_disk.value.id  # ID диска
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}" # Добавляем SSH-ключ для пользователя ubuntu
  }
}