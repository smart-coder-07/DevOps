variable "project_id" { type = string }
variable "region"     { type = string  default = "asia-south1" }
variable "zone"       { type = string  default = "asia-south1-a" }

variable "vm_name"      { type = string default = "jenkins-angular-vm" }
variable "machine_type" { type = string default = "e2-medium" }

variable "ssh_user"         { type = string default = "ubuntu" }
variable "ssh_pub_key_path" { type = string }