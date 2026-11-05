variable "box_version" {
  type        = string
  default     = "1.0.0"
  description = "Version stamped into the built box name"
}

variable "base_box" {
  type    = string
  default = "bento/ubuntu-24.04"
}

locals {
  box_name = "xops-ubuntu-${var.box_version}"
}

packer {
  required_plugins {
    vagrant = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "vagrant" "ubuntu" {
  source_path  = var.base_box
  provider     = "virtualbox"
  communicator = "ssh"
  add_force    = true

  box_name   = local.box_name
  output_dir = "output-${var.box_version}"

  # Використовуємо наш кастомний Vagrantfile з увімкненим GUI
  output_vagrantfile = "Vagrantfile"
}

build {
  name    = "xops-ubuntu"
  sources = ["source.vagrant.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo '--- waiting for cloud-init to finish ---'",
      "cloud-init status --wait || true",
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx git curl htop",
      "echo '<h1>Baked by Packer</h1>' | sudo tee /var/www/html/index.html",
      "sudo systemctl enable nginx",
    ]
  }
}