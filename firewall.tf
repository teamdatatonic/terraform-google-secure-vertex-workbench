locals {
  default_fw_rules = [
    {
      name                    = "ingress-allow-tcp-git"
      description             = "To allow connection to GitHub git endpoints - Ingress"
      direction               = "INGRESS"
      priority                = 65534
      ranges                  = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20", "13.114.40.48/32", "52.192.72.89/32", "52.69.186.44/32", "15.164.81.167/32", "52.78.231.108/32", "13.234.176.102/32", "13.234.210.38/32", "13.236.229.21/32", "13.237.44.5/32", "52.64.108.95/32", "20.201.28.151/32", "20.205.243.166/32", "102.133.202.242/32", "18.181.13.223/32", "54.238.117.237/32", "54.168.17.15/32", "3.34.26.58/32", "13.125.114.27/32", "3.7.2.84/32", "3.6.106.81/32", "52.63.152.235/32", "3.105.147.174/32", "3.106.158.203/32", "20.201.28.152/32", "20.205.243.160/32", "102.133.202.246/32"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["22", "80", "443", "9418"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "egress-allow-tcp-git"
      description             = "To allow connection to GitHub git endpoints - Egress"
      direction               = "EGRESS"
      priority                = 65534
      ranges                  = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20", "13.114.40.48/32", "52.192.72.89/32", "52.69.186.44/32", "15.164.81.167/32", "52.78.231.108/32", "13.234.176.102/32", "13.234.210.38/32", "13.236.229.21/32", "13.237.44.5/32", "52.64.108.95/32", "20.201.28.151/32", "20.205.243.166/32", "102.133.202.242/32", "18.181.13.223/32", "54.238.117.237/32", "54.168.17.15/32", "3.34.26.58/32", "13.125.114.27/32", "3.7.2.84/32", "3.6.106.81/32", "52.63.152.235/32", "3.105.147.174/32", "3.106.158.203/32", "20.201.28.152/32", "20.205.243.160/32", "102.133.202.246/32"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["22", "80", "443", "9418"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "egress-deny-all"
      description             = "Blanket default deny rule for egress"
      direction               = "EGRESS"
      priority                = 65535
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow                   = []
      deny = [{
        protocol = "all"
        ports    = null # All ports
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "ingress-allow-tcp-ssh-from-iap"
      description             = "FW rules required to ssh into instances via IAP - useful for diagnosing faulty notebooks/instances"
      direction               = "INGRESS"
      priority                = 65534
      ranges                  = ["35.235.240.0/20"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "egress-allow-private-gcp-services"
      description             = "Allow egress from instances in this network to the google service apis private range"
      direction               = "EGRESS"
      priority                = 65534
      ranges                  = ["199.36.153.8/30"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "all"
        ports    = null # All ports
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "egress-allow-restricted-gcp-services"
      description             = "Allow egress from instances in this network to the google service apis restricted range"
      direction               = "EGRESS"
      priority                = 65534
      ranges                  = ["199.36.153.4/30"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "all"
        ports    = null # All ports
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "egress-allow-fastly-cdn-for-pypi"
      description             = "Allow egress from instances in this network to the Fastly CDN IP Ranges, which is used by PyPi"
      direction               = "EGRESS"
      priority                = 65534
      ranges                  = ["23.235.32.0/20", "43.249.72.0/22", "103.244.50.0/24", "103.245.222.0/23", "103.245.224.0/24", "104.156.80.0/20", "140.248.64.0/18", "140.248.128.0/17", "146.75.0.0/17", "151.101.0.0/16", "157.52.64.0/18", "167.82.0.0/17", "167.82.128.0/20", "167.82.160.0/20", "167.82.224.0/20", "172.111.64.0/18", "185.31.16.0/22", "199.27.72.0/21", "199.232.0.0/16"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["443", "3128"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
  fw_rules = concat(local.default_fw_rules, var.additional_fw_rules)
}

resource "google_compute_firewall" "fw_rules" {
  for_each                = { for rule in local.fw_rules : rule.name => rule }
  network                 = google_compute_network.vpc_network.name
  project                 = var.project
  name                    = each.value.name
  description             = each.value.description
  direction               = each.value.direction
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]
    content {
      metadata = log_config.value.metadata
    }
  }

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }
}