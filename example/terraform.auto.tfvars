project              = "dt-architecture-framework-dev"
zone                 = "europe-west1-b"
region               = "europe-west1"
vpc_network_name     = "example-vpc"
subnet_ip_cidr_range = "10.1.0.0/24"
gcs_bucket_name      = "example-bucket-stan-3238294u72"
gcs_labels           = { "foo" : "bar" }

notebooks = {
  "example-nb-instance" : {
    "labels" : { "foo" : "bar" },
    "instance_owners" : ["stan.hill@datatonic.com"]
    "metadata" : {}
  }
}

additional_vertex_nb_sa_roles = [
  "roles/dataproc.editor",
  "roles/dataproc.hubAgent"
]

additional_fw_rules = [{
  name                    = "egress-allow-example-google"
  description             = "Allow egress example"
  direction               = "EGRESS"
  priority                = 65534
  ranges                  = ["142.250.178.14/32"] # google.com
  source_tags             = null
  source_service_accounts = null
  target_tags             = null
  target_service_accounts = null
  allow = [{
    protocol = "tcp"
    ports    = ["443"]
  }]
  deny = []
  log_config = {
    metadata = "INCLUDE_ALL_METADATA"
  }
}]