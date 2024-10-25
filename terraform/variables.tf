variable "ibmcloud_api_key" {}
variable "region" {}
variable "resource_group_id" {}
variable "es_name" {}
variable "es_username" {}
variable "es_password" {}
variable "es_version" {
  default = "8.15"
}
variable "es_ram_mb" {
  default = 6144
}
variable "es_disk_mb" {
  default = 51200
}

variable "es_cpu_count" {
  default = 3
}
