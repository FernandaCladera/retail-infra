output "project_id" {
  value = google_project.dev.project_id
}

output "tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "GCP_WIF_PROVIDER" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "GCP_TERRAFORM_SA" {
  value = google_service_account.github_terraform.email
}
