
data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}


resource "yandex_compute_instance" "web" {
  name        = "netology-develop-platform-web-${tostring(count.index+1)}"
  platform_id = var.vms_defaultsettings.platform_id
  
  count = 2

  resources {
    cores  = var.vms_defaultsettings.resources.cpu
    memory = var.vms_defaultsettings.resources.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = var.vms_defaultsettings.disktype
      size = var.vms_defaultsettings.disksize
    }   
  }

  metadata = local.vms_metadata

  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}
