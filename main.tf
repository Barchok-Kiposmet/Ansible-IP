terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.67.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  count        = length(var.instances)
  name         = var.instances[count.index]
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

