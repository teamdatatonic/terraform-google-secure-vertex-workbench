# In locals here, we are specifying whether the dns response policy rules should use the restricted google apis domain ips (suitable when using VPC SC) or the private domain ips (suitable for non-VPC SC situations)
locals {
  restricted_googleapis_ips = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
  private_googleapis_ips    = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  rrdatas                   = var.vpc_sc_enabled ? local.restricted_googleapis_ips : local.private_googleapis_ips
}

resource "google_dns_response_policy" "pga-response-policy" {
  provider = google-beta

  project              = var.project
  response_policy_name = "private-google-access"
  description          = "DNS Response Policy for enabling private access to Google Services APIs, gcr.io, pkr.dev and any other required hostnames"

  networks {
    network_url = google_compute_network.vpc_network.id
  }
}

resource "google_dns_response_policy_rule" "googleapis-response-policy-rule" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "googleapis"
  dns_name        = "*.googleapis.com."

  local_data {
    local_datas {
      name    = "*.googleapis.com."
      type    = "A"
      ttl     = 3600
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "gcr-response-policy-rule" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "gcr"
  dns_name        = "*.gcr.io."

  local_data {
    local_datas {
      name    = "*.gcr.io."
      type    = "A"
      ttl     = 3600
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "pkg-dev-response-policy-rule" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "pkg-dev"
  dns_name        = "*.pkg.dev."

  local_data {
    local_datas {
      name    = "*.pkg.dev."
      type    = "A"
      ttl     = 3600
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "notebooks-response-policy-rule" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "notebooks"
  dns_name        = "*.notebooks.cloud.google.com."

  local_data {
    local_datas {
      name    = "*.notebooks.cloud.google.com."
      type    = "A"
      ttl     = 3600
      rrdatas = local.rrdatas
    }
  }
}