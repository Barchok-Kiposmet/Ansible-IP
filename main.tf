locals {
  project_id       = var.project_id
  network          = "default"
  image            = "debian-cloud/debian-11"
  ssh_user         = "ansible"
  private_key_path = "/Users/patrickkiposmet/.ssh/id_rsa"
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_service_account" "ansible" {
  account_id = "ansible-admin"
}

resource "google_compute_firewall" "web" {
  name    = "web-access"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_instance" "vm_instance" {
  count        = length(var.instances)
  name         = var.instances[count.index]
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = local.network

    access_config {
      // Removed empty block
    }
  }

  tags = ["web"]

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "local-exec" {
    environment = {
      "LANG" = "en_US.UTF-8"
    }
    command = "ansible-playbook -i ${self.network_interface[0].access_config[0].nat_ip}, --private-key ${local.private_key_path} playbook.yaml"
  }
  
}

## allows us to access the output for the web access.
output "vm_instance" {
  value = {
    for k, v in google_compute_instance.vm_instance : k => "http://${v.network_interface.0.access_config.0.nat_ip}"
  }
}
