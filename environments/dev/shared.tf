data "google_project" "this" {}

# One docker registry for all app images (ecommerce, erp, pim)
resource "google_artifact_registry_repository" "apps" {
  repository_id = "apps"
  location      = var.region
  format        = "DOCKER"
  description   = "Container images for retail-sim services"
}

# Identity the APP repos use to push images and deploy to Cloud Run
resource "google_services_account" "github_deployer" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions - app deployments"
}

locals {
  deployer_roles = [
    "roles/run.developer",
    "roles/artifactregistry.writer",
    "roles/iam.serviceAccountUser",
  ]
  wif_pool = "projects/${data.google_project.this.number}/locations/global/workloadIdentityPools/github"
}

resource "google_project_iam_member" "github_deployer" {
  for_each = toset(local.deployer_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github_deployer.email}"
}
