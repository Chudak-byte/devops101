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
  communicator = "ssh"
  source_path  = var.base_box
  box_name     = local.box_name
  output_dir   = "output-${var.box_version}"
}

build {
  name    = "xops-ubuntu"
  sources = ["source.vagrant.ubuntu"]

  provisioner "shell" {
    inline = [
      "cloud-init status --wait || true",
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx git curl htop",
      "echo '<h1>Baked by Packer</h1>' | sudo tee /var/www/html/index.html",
      "echo 'xops-image-v1.0.0' | sudo tee /etc/xops-image",
      "sudo systemctl enable nginx"
    ]
  }

  provisioner "shell" {
    inline = [
      "git --version || { exit 1; }",
      "curl --version || { exit 1; }",
      "htop --version || { exit 1; }",
      "nginx -v || { exit 1; }",
      "sudo systemctl is-enabled --quiet nginx || { exit 1; }",
      "[ -f /etc/xops-image ] || { exit 1; }"
    ]
  }
}