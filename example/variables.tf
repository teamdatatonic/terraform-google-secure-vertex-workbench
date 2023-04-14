variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "zone" {
  description = "The GCP Zone for Vertex Notebook User-Managed Instances"
  type        = string
}

variable "region" {
  description = "The GCP region for the GCS bucket and Artifact Registry"
  type        = string
}

variable "notebooks" {
  description = "A map containing the containing the configuration for the desired Vertex AI Workbench User-Managed Notebooks"
  type = map(object({
    labels         = map(string),
    instance_owner = string,
    metadata       = map(string),
    type           = string,
    access_type    = optional(string)
  }))
  default = {}
}

variable "additional_vertex_nb_sa_roles" {
  description = "Additional roles that you may want to assign to the Vertex AI NB SA"
  type        = list(string)
  default     = []
}

variable "vpc_network_name" {
  description = "The name of your VPC Network"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "The name of your VPC Subnetwork"
  type        = string
  default     = "10.0.0.0/21"
}

variable "gcs_bucket_name" {
  description = "Name of the GCS Bucket that will contain the post startup script"
  type        = string
}

variable "gcs_labels" {
  description = "Labels to attach to the GCS Bucket. Useful for labelling resources for billing purposes"
  type        = map(string)
  default     = null
}

variable "additional_fw_rules" {
  description = "Additional firewall rules that you may want to create to allow other traffic"
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = optional(object({
      metadata = string
    }))
  }))
  default = []
}
