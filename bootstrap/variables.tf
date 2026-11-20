variable "org_id" {
  type = string
}

variable "billing_account_id" {
  type = string
}

variable "folder_name" {
  type    = string
  default = "retail-sim"
}

variable "project_id" {
  description = "Unico en todo GCP"
  type        = string
}

variable "project_name" {
  type    = string
  default = "retail-sim-dev"
}

variable "region" {
  type    = string
  default = "europe-west16"
}

variable "budget_amount" {
  type    = number
  default = 20
}

variable "budget_currency" {
  description = "Currency for billing"
  type        = string
  default     = "CHF"
}


variable "github_owner" {
  type = string
}

variable "infra_repo" {
  type    = string
  default = "retail-infra"
}
