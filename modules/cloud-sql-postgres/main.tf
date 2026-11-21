
resource "google_sql_database_instance" "this" {
  name                = var.name
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    edition           = "ENTERPRISE"
    tier              = var.tier
    activation_policy = var.activation_policy
    availability_type = "ZONAL"
    disk_size         = 10
    disk_autoresize   = true
    backup_configuration {
      enabled = var.backups_enabled
    }
    ip_configuration {
      ipv4_enabled = true
    }
    database_flags {
      name  = "cloudsql.logical_decoding"
      value = "on"
    }
  }
}

resource "google_sql_database" "this" {
  name     = var.database_name
  instance = google_sql_database_instance.this.name
}

resource "random_password" "app" {
  length  = 32
  special = false
}

resource "google_sql_user" "app" {
  name     = var.app_user
  instance = google_sql_database_instance.this.name
  password = random_password.app.result
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.name}-password"
  replication {
    auto {}
  }
}
resource "google_secret_manager_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.app.result
}
