resource "ibm_database" "elastic" {
  name          = "elastic-ess"
  service       = "databases-for-elasticsearch"
  plan          = "platinum"
  version       = var.es_version
  location      = var.region
  adminpassword = var.es_password
}

data "ibm_database_connection" "es_connection" {
  endpoint_type = "public"
  deployment_id = ibm_database.elastic.id
  user_id       = "admin"
  user_type     = "database"
}

output "es_host" {
  value = data.ibm_database_connection.es_connection.https[0].hosts[0].hostname
}

output "es_port" {
  value = data.ibm_database_connection.es_connection.https[0].hosts[0].port
}

output "es_password" {
  value     = ibm_database.elastic.adminpassword
  sensitive = true
}

output "es_url" {
    value="https://admin:${ibm_database.elastic.adminpassword}@${data.ibm_database_connection.es_connection.https[0].hosts[0].hostname}:${data.ibm_database_connection.es_connection.https[0].hosts[0].port}"
    sensitive = true
}

output "es_version" {
  value = ibm_database.elastic.version
}
