variable "region" {
  description = "AWS region"
  type        = string
}

variable "playground_vpc" {
  description = "VPC for Playground environment"
}

variable "playground_network_cidr" {
  description = "Network CIDR for Playground VPC"
}

variable "playground_public_01_cidr" {
  description = "Public CIDR for externally accessible subnet"
}

variable "playground_public_02_cidr" {
  description = "Public CIDR for externally accessible subnet"
}