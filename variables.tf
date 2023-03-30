variable "DB_HOST" {
  description = "hostname for the database"
  type        = string
}

variable "DB_USER" {
  description = "database user"
  type        = string
}

variable "DB_PASSWORD" {
  description = "databse access key"
  type        = string
}

variable "DB_DATABASE" {
  description = "database name"
  type        = string
}

variable "JWT_KEY" {
  description = "jwt secret"
  type        = string
}

variable "CLOUDFLARE_API_TOKEN" {
  description = "Cloudflare api to edit dns entries"
  type        = string
}

variable "CLOUDFLARE_ZONE_ID" {
  description = "zone id for cloudflare zone"
  type        = string
}

variable "GHCR_USERNAME" {
  description = "username for the github's registry"
  type        = string
}

variable "GHCR_PASSWORD" {
  description = "Token to login in github's registry"
  type        = string
}
