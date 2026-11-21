
output "ecommerce_api_url" {
  value = module.ecommerce_api.url
}

output "ecommerce_web_url" {
  value = module.ecommerce_web.url
}

output "artifact_registry" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.apps.repository_id}"
}

output "github_deployer_sa" {
  value = google_service_account.github_deployer.email
}

output "wif_provider" {
  value = "${local.wif_pool}/providers/github-oidc"
}
