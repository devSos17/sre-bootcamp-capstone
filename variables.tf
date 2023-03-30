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
