
output "connection_name" {
  value = google_sql_database_instance.this.connection_name
}

output "database_name" {
  value = google_sql_database.this.name
}

output "app_user" {
  value = google_sql_user.app.name
}

output "password_secret_id" {
  value = google_secret_manager_secret.db_password.secret_id
}
