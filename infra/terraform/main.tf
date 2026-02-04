terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc" {
  name                    = "cicd-vpc"
  auto_create_subnetworks = true
}

# PUBLIC SSH (22) - open to world (not recommended, but per your ask)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-public"
  network = google_compute_network.vpc.name

  allow { protocol = "tcp" ports = ["22"] }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cicd"]
}

# PUBLIC Jenkins UI (8080)
resource "google_compute_firewall" "allow_jenkins" {
  name    = "allow-jenkins-public"
  network = google_compute_network.vpc.name

  allow { protocol = "tcp" ports = ["8080"] }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cicd"]
}

# PUBLIC App port (8000)
resource "google_compute_firewall" "allow_app" {
  name    = "allow-app-public"
  network = google_compute_network.vpc.name

  allow { protocol = "tcp" ports = ["8000"] }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cicd"]
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  tags         = ["cicd"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  # For Ansible: ensure python exists
  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y python3
  EOT
}
