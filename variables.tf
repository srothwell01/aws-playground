### VPC and networking ###
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

variable "playground_private_01_cidr" {
  description = "Private CIDR for restricted access subnet"
}

### ECS and app ###

variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "ECS key pair name"
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}