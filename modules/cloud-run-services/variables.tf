
variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "service_account_email" {
  description = "Identity the service runs as"
  type        = string
}

variable "image" {
  description = "Placeholder until the app repo deploys its real image"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "port" {
  type    = number
  default = 8080
}

variable "cpu" {
  type    = string
  default = "1"
}

variable "memory" {
  type    = string
  default = "512Mi"
}

variable "max_instances" {
  type    = number
  default = 2
}

variable "public" {
  type    = bool
  default = true
}

variable "env" {
  description = "Plain environment variables"
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "ENV_NAME => Secret Manager id"
  type        = map(string)
  default     = {}
}

variable "cloudsql_instances" {
  description = "Cloud SQL connection names to mount"
  type        = list(string)
  default     = []
}
