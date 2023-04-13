# Common Variables

variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "zone" {
  description = "The GCP Zone for Vertex Notebook User-Managed Instances"
  type        = string
  default     = "europe-west1-b"
}

variable "region" {
  description = "The GCP region for the GCS bucket and Artifact Registry"
  type        = string
  default     = "europe-west1"
}

# Notebooks Variables

variable "notebooks" {
  description = "A map containing the containing the configuration for the desired Vertex AI Workbench User-Managed Notebooks"
  type = map(object({
    labels          = map(string),
    instance_owners = string,
    metadata        = map(string),
    type            = string,
    access_type     = optional(string)
  }))
  default = {}
}

variable "image_project" {
  description = "GCP Project conataining VM image for the Notebook instances"
  type        = string
  default     = "deeplearning-platform-release"
}

variable "image_family" {
  description = "Image family for the Notebook instances (https://cloud.google.com/compute/docs/images)"
  type        = string
  default     = "common-cpu"
}

variable "machine_type" {
  description = "The Notebook Instance's machine type"
  type        = string
  default     = "n1-standard-4"
}

variable "boot_disk_type" {
  description = "Boot disk type for notebook instances. Possible values are DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD and PD_BALANCED"
  type        = string
  default     = "PD_STANDARD"
}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB attached to notebook instances, up to a maximum of 64 TB. The minimum recommended value is 100GB."
  type        = number
  default     = 100
}

variable "data_disk_size_gb" {
  description = "The size of the data disk in GB attached to notebook instances, up to a maximum of 64 TB. You can choose the size of the data disk based on how big your notebooks and data are."
  type        = number
  default     = 100
}

variable "no_remove_data_disk" {
  description = "If true, the data disk will not be auto deleted when deleting the instance."
  type        = bool
  default     = true
}

variable "install_gpu_driver" {
  description = "Whether the end user authorizes Google Cloud to install GPU driver on this instance. If this field is empty or set to false, the GPU driver won't be installed. Only applicable to instances with GPUs."
  type        = string
  default     = false
}

variable "accelerator_type" {
  description = "Type of accelerator. Possible values are ACCELERATOR_TYPE_UNSPECIFIED, NVIDIA_TESLA_K80, NVIDIA_TESLA_P100, NVIDIA_TESLA_V100, NVIDIA_TESLA_P4, NVIDIA_TESLA_T4, NVIDIA_TESLA_T4_VWS, NVIDIA_TESLA_P100_VWS, NVIDIA_TESLA_P4_VWS, NVIDIA_TESLA_A100, TPU_V2, and TPU_V3"
  type        = string
  default     = "ACCELERATOR_TYPE_UNSPECIFIED"
}


variable "accelerator_core_count" {
  description = "Count cores of accelerator."
  type        = number
  default     = 1
}

variable "access_type" {
  description = "Access type for Runtime Notebooks. Possible values are SINGLE_USER, SERVICE_ACCOUNT and RUNTIME_ACCESS_TYPE_UNSPECIFIED"
  type        = string
  default     = "SINGLE_USER"
}

# IAM Variables

variable "additional_vertex_nb_sa_roles" {
  description = "Additional roles that you may want to assign to the Vertex AI NB SA"
  type        = list(string)
  default     = []
}

# VPC Network Variables

variable "vpc_network_name" {
  description = "The name of your VPC Network"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "The name of your VPC Subnetwork"
  type        = string
  default     = "10.0.0.0/21"
}

# DNS Variables

variable "vpc_sc_enabled" {
  description = "A boolean flag to signal whether this enviornment is inside a VPC SC Perimeter"
  type        = bool
  default     = false
}

# GCS Bucket Name

variable "gcs_bucket_name" {
  description = "Name of the GCS Bucket that will contain the post startup script"
  type        = string
}

variable "gcs_labels" {
  description = "Labels to attach to the GCS Bucket. Useful for labelling resources for billing purposes"
  type        = map(string)
  default     = null
}

# Firewall Rules Variables

variable "additional_fw_rules" {
  description = "Additional firewall rules that you may want to create to allow other traffic"
  type        = list(any)
  default     = []
}
