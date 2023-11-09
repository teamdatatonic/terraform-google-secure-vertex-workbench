project              = "dt-architecture-framework-dev"
zone                 = "europe-west1-b"
region               = "europe-west1"
vpc_network_name     = "example-vpc"
subnet_ip_cidr_range = "10.1.0.0/24"
gcs_bucket_name      = "stan-fqdn-test-ejfwe"
gcs_labels           = { "foo" : "bar" }

notebooks = {
  "example-user-managed-instance" : {
    "nb_labels" : {},
    "instance_owner" : "stan.hill@datatonic.com"
    "metadata" : {}
    "type" : "user-managed-notebook",
  }
  "example-google-managed-instance" : {
    "nb_labels" : {},
    "instance_owner" : "stan.hill@datatonic.com"
    "metadata" : {}
    "access_type" : "SERVICE_ACCOUNT"
    "type" : "google-managed-notebook"
  }
}

additional_vertex_nb_sa_roles = [
  "roles/dataproc.editor",
  "roles/dataproc.hubAgent"
]

additional_fw_rules = [
  {
    name        = "allow-huggingface-egress"
    description = "Allow Egress to Hugging Face"
    action = "allow"
    direction   = "EGRESS"
    disabled = false
    priority    = 100
    enable_logging = false
    target_service_accounts = null
    match = [{
      dest_address_groups = null
      dest_fqdns = ["huggingface.co"]
      dest_ip_ranges  = null
      dest_region_codes = null
      dest_threat_intelligences = null
      src_address_groups = null
      src_fqdns = null
      src_ip_ranges = null
      src_region_codes = null
      src_threat_intelligences = null
      ip_protocol = "all"
    }]
}]