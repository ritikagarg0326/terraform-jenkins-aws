variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}



variable "security_group_id" {
  type = string
}

variable "target_instance_id" {
  type = string
}

variable "target_port" {
  type    = number
  default = 8080
}
variable "public_subnet_ids" {
  type = list(string)
}