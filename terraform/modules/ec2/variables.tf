variable "zone" {
  type        = string
  default     = "us-east-1a"
}

variable "vpc_id" {
  type        = string
}

variable "cidr" {
  type        = string
}

variable "instance_name" {
  description = "docker image to pull and run"
  type        = string
  default     = "ghcr.io/devsos17/academy-sre-bootcamp-santiago-orozco:latest"
}

variable "docker_image" {
  description = "docker image to pull and run"
  type        = string
  default     = "ghcr.io/devsos17/academy-sre-bootcamp-santiago-orozco:latest"
}

variable "security_group_ids" {
  description = "Sg ids"
  type        = list(any)
}

variable "db_host" {
  description = "hostname for the database"
  type        = string
}

variable "db_user" {
  description = "database user"
  type        = string
}

variable "db_password" {
  description = "databse access key"
  type        = string
}

variable "db_database" {
  description = "database name"
  type        = string
}

variable "jwt_key" {
  description = "jwt secret"
  type        = string
}

variable "ghcr_user" {
  description = "username for the github's registry"
  type        = string
}

variable "ghcr_token" {
  description = "Token to login in github's registry"
  type        = string
}
