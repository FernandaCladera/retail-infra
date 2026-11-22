
resource "google_cloud_run_v2_service" "this" {
  name                 = var.name
  location             = var.region
  ingress              = "INGRESS_TRAFFIC_ALL"
  deletion_protection  = false
  invoker_iam_disabled = var.public

  template {
    service_account = var.service_account_email
    scaling {
      min_instance_count = 0
      max_instance_count = var.max_instances
    }
    dynamic "volumes" {
      for_each = length(var.cloudsql_instances) > 0 ? [1] : []
      content {
        name = "cloudsql"
        cloud_sql_instance {
          instances = var.cloudsql_instances
        }
      }
    }
    containers {
      image = var.image
      ports {
        container_port = var.port
      }
      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
        cpu_idle = true
      }

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }

      dynamic "volume_mounts" {
        for_each = length(var.cloudsql_instances) > 0 ? [1] : []
        content {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version
    ]
  }
}

