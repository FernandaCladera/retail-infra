# -- Folder ----------------
resource "google_folder" "retail_sim" {
  display_name = var.folder_name
  parent       = "organizations/${var.org_id}"
}

#  -- Project -----------
resource "google_project" "dev" {
  project_id          = var.project_id
  name                = var.project_name
  folder_id           = google_folder.retail_sim.name
  billing_account     = var.billing_account_id
  auto_create_network = false
  deletion_policy     = "PREVENT"
}

# -- APIs --------------------

locals {
  apis = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "storage.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "bigquery.googleapis.com",
    "pubsub.googleapis.com",
  ]
}


resource "google_project_service" "apis" {
  for_each           = toset(local.apis)
  project            = google_project.dev.project_id
  service            = each.value
  disable_on_destroy = false
}


# -- Bucket state ------------------
resource "google_storage_bucket" "tfstate" {
  project                     = google_project.dev.project_id
  name                        = "${var.project_id}-tfstate"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 10
    }
    action {
      type = "Delete"
    }
  }
  depends_on = [google_project_service.apis]
}

# -- Budget -----------------------
resource "google_billing_budget" "monthly" {
  provider        = google.project
  billing_account = var.billing_account_id
  display_name    = "${var.project_id} monthly budget"

  budget_filter {
    projects = ["projects/${google_project.dev.number}"]
  }

  amount {
    specified_amount {
      currency_code = var.budget_currency
      units         = tostring(var.budget_amount)
    }
  }

  threshold_rules { threshold_percent = 0.5 }
  threshold_rules { threshold_percent = 0.9 }
  threshold_rules { threshold_percent = 1.0 }

  depends_on = [google_project_service.apis]

}
