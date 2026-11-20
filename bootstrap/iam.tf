resource "google_service_account" "github_terraform" {
  project      = google_project.dev.project_id
  account_id   = "github-terraform"
  display_name = "GitHub Actions - terraform"
  depends_on   = [google_project_service.apis]
}

locals {
  ci_roles = [
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
    "roles/secretmanager.admin",
    "roles/iam.serviceAccountAdmin",
  ]
}

resource "google_project_iam_member" "github_terraform" {
  for_each = toset(local.ci_roles)
  project  = google_project.dev.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github_terraform.email}"
}

# Login without keys:

resource "google_iam_workload_identity_pool" "github" {
  project                   = google_project.dev.project_id
  workload_identity_pool_id = "github"
  display_name              = "Github Actions"
  depends_on                = [google_project_service.apis]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = google_project.dev.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "Github OIDC"


  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
  }

  attribute_condition = "assertion.repository_owner == '${var.github_owner}'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}


resource "google_service_account_iam_member" "github_wif" {
  service_account_id = google_service_account.github_terraform.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.infra_repo}"
}
