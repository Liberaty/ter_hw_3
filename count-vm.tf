# Создание двух одинаковых ВМ (web-1 и web-2)
resource "yandex_compute_instance" "web" {
  count        = 2
  name         = "${var.vm_web_config[count.index].name}-${count.index + 1}" # Генерация name: web-1, web-2
  hostname     = "${var.vm_web_config[count.index].name}-${count.index + 1}" # Генерация hostname: web-1, web-2
  platform_id  = var.vm_web_config[count.index].platform_id
  zone         = var.vm_web_config[count.index].zone

  resources {
    cores         = var.vm_web_config[count.index].cores
    memory        = var.vm_web_config[count.index].memory
    core_fraction = var.vm_web_config[count.index].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id  = data.yandex_compute_image.ubuntu.image_id # Ubuntu 20.04 LTS
      size      = var.vm_web_config[count.index].hdd_size
      type      = var.vm_web_config[count.index].hdd_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_config[count.index].nat_ip
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}" # Добавляем SSH-ключ для пользователя ubuntu
  }

  depends_on = [yandex_compute_instance.db, yandex_compute_instance.storage] # Ожидаем создания ВМ из for_each-vm.tf и disk_vm.tf
}