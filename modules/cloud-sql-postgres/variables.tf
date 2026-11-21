
variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_version" {
  type    = string
  default = "POSTGRES_16"
}

variable "tier" {
  description = "db-f1-micro = cheapest shared-core machine"
  type        = string
  default     = "db-f1-micro"
}

variable "app_user" {
  type    = string
  default = "app"
}

variable "activation_policy" {
  description = "ALWAYS =running(billed), NEVER = stopped (only disk billed)"
  type        = string
  default     = "ALWAYS"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "backups_enabled" {
  type    = bool
  default = false
}
