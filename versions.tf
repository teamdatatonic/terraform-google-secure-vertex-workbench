terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 0.14.5"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 0.14.5"
    }
  }
}
