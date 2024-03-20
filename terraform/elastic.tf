resource "ibm_database" "elastic" {
  name          = "elastic-ess"
  service       = "databases-for-elasticsearch"
  plan          = "platinum"
  version       = var.es_version
  location      = var.region
  adminpassword = var.es_password

  group {
    group_id = "member"

    memory {
      allocation_mb = var.es_ram_mb
    }

    disk {
      allocation_mb = var.es_disk_mb
    }

    cpu {
      allocation_count = var.es_cpu_count
    }
  }
}

data "ibm_database_connection" "es_connection" {
  endpoint_type = "public"
  deployment_id = ibm_database.elastic.id
  user_id       = var.es_username
  user_type     = "database"
}

output "es_url" {
  value     = "https://admin:${ibm_database.elastic.adminpassword}@${data.ibm_database_connection.es_connection.https[0].hosts[0].hostname}:${data.ibm_database_connection.es_connection.https[0].hosts[0].port}"
  sensitive = true
}
