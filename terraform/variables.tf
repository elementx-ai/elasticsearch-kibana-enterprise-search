variable "ibmcloud_api_key" {}
variable "region" {}
variable "es_username" {}
variable "es_password" {}
variable "es_version" {}
variable "es_minor_version" {
    default = "1"
}
variable "es_ram_mb" {
    default = 4096
}

variable "es_disk_mb" {
    default = 102400
}

variable "es_cpu_count" {
    default = 3
}