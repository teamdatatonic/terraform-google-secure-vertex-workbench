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

resource "google_dns_response_policy_rule" "priv-googleapis-response-policy-rule-a" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "priv-googleapis-a"
  dns_name        = "private.googleapis.com."

  local_data {
    local_datas {
      name    = "private.googleapis.com."
      type    = "A"
      ttl     = 300
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "googleapis-response-policy-rule-cname" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "googleapis-cname"
  dns_name        = "*.googleapis.com."

  local_data {
    local_datas {
      name    = "*.googleapis.com."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["private.googleapis.com."]
    }
  }
}

resource "google_dns_response_policy_rule" "gcr-response-policy-rule-cname" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "gcr-io-cname"
  dns_name        = "*.gcr.io."

  local_data {
    local_datas {
      name    = "*.gcr.io."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["gcr.io."]
    }
  }
}

resource "google_dns_response_policy_rule" "gcr-response-policy-rule-a" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "gcr-io-a"
  dns_name        = "gcr.io."

  local_data {
    local_datas {
      name    = "gcr.io."
      type    = "A"
      ttl     = 300
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "pkg-dev-response-policy-rule-cname" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "pkg-dev-cname"
  dns_name        = "*.pkg.dev."

  local_data {
    local_datas {
      name    = "*.pkg.dev."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["pkg.dev."]
    }
  }
}

resource "google_dns_response_policy_rule" "pkg-dev-response-policy-rule-a" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "pkg-dev-a"
  dns_name        = "pkg.dev."

  local_data {
    local_datas {
      name    = "pkg.dev."
      type    = "A"
      ttl     = 300
      rrdatas = local.rrdatas
    }
  }
}

resource "google_dns_response_policy_rule" "notebooks-response-policy-rule-cname" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "notebooks-cname"
  dns_name        = "*.notebooks.cloud.google.com."

  local_data {
    local_datas {
      name    = "*.notebooks.cloud.google.com."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["notebooks.cloud.google.com."]
    }
  }
}

resource "google_dns_response_policy_rule" "notebooks-response-policy-rule-a" {
  provider = google-beta

  project         = var.project
  response_policy = google_dns_response_policy.pga-response-policy.response_policy_name
  rule_name       = "notebooks-a"
  dns_name        = "notebooks.cloud.google.com."

  local_data {
    local_datas {
      name    = "notebooks.cloud.google.com."
      type    = "A"
      ttl     = 300
      rrdatas = local.rrdatas
    }
  }
}
