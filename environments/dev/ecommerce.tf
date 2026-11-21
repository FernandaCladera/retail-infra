locals {
  ecommerce_repo = "retail-ecommerce"
}

# -- Identitites (one per service) -----------
resource "google_service_account" "ecommerce_api" {
  account_id   = "ecommerce-api"
  display_name = "Cloud Run runtime: ecommerce-api"
}

resource "google_service_account" "ecommerce_web" {
  account_id   = "ecommerce_web"
  display_name = "Cloud Run runtime: ecommerce-web"
}

# -- Database --------------------------------
module "ecommerce_db" {
  source        = "../../modules/cloud-sql-postgres"
  name          = "ecommerce-db"
  region        = var.region
  database_name = "ecommerce"
}

# -- Permissions for the API ----------------
resource "google_project_iam_member" "ecommerce_api_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.ecommerce_api.email}"
}

resource "google_secret_manager_secret_iam_member" "ecommerce_api_db_password" {
  secret_id = module.ecommerce_db.password_secret_id
  role      = "roles/secretmanager.secretAccesor"
  member    = "serviceAccount:${google_service_account.ecommerce_api.email}"
}

# -- API (FastAPI) ------------------
module "ecommerce_api" {
  source                = "../../modules/cloud-run-services"
  name                  = "ecommerce-api"
  region                = var.region
  service_account_email = google_service_account.ecommerce_api.email

  cloudsql_instances = [module.ecommerce_db.connection_name]

  env = {
    DB_HOST = "/cloudsql/${module.ecommerce_db.connection_name}"
    BD_NAME = module.ecommerce_db.database_name
    DB_USER = module.ecommerce_db.app_user
  }
  secret_env = {
    DB_PASSWORD = module.ecommerce_db.password_secret_id
  }

  depends_on = [
    module.ecommerce_db,
    google_project_iam_member.ecommerce_api_sql,
    google_secret_manager_secret_iam_member.ecommerce_api_db_password,
  ]
}

# ── Web (Next.js) ──────────────────────────────────────────
module "ecommerce_web" {
  source                = "../../modules/cloud-run-service"
  name                  = "ecommerce-web"
  region                = var.region
  service_account_email = google_service_account.ecommerce_web.email
  port                  = 3000

  env = {
    API_URL = module.ecommerce_api.url
  }
}

# ── Let the retail-ecommerce repo deploy (keyless) ──────────
resource "google_service_account_iam_member" "ecommerce_repo_deployer" {
  service_account_id = google_service_account.github_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${local.wif_pool}/attribute.repository/${var.github_owner}/${local.ecommerce_repo}"
}
