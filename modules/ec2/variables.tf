variable "image" {
  type        = string
  default     = "ami-02f3f602d23f1659d"
}

variable "zone" {
  type        = string
  default     = "us-east-1a"
}

variable "instance_name" {
  description = "docker image to pull and run"
  type        = string
  default     = "ghcr.io/devsos17/academy-sre-bootcamp-santiago-orozco:latest"
}

variable "container" {
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
