variable "images" {
  description = "choose image for any region"
  type        = map(any)
  default = {
    us-east-1 = "ami-02f3f602d23f1659d"
    us-east-2 = "ami-074cce78125f09d61"
    us-west-1 = "ami-06604eb73be76c003"
    us-west-2 = "ami-0d2017e886fc2c0ab"
  }
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
