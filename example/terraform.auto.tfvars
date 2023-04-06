project              = "dt-ariadna-sandbox-dev"
zone                 = "europe-west1-b"
region               = "europe-west1"
vpc_network_name     = "notebooks-vpc"
subnet_ip_cidr_range = "10.1.0.0/24"
gcs_bucket_name      = "notebook-um-example-ariadna"
gcs_labels           = { "foo" : "bar" }

notebooks = {
  "example-runtime-instance" : {
    "labels" : { "foo" : "bar" },
    "instance_owners" : ["ariadna.fernandez@datatonic.com"] # In user managed notebooks we need a list
    "access_type": "SINGLE_USER"
    "metadata" : {}
    "type": "user-managed-notebook",
  }
  "example-user-manage-instance" : {
    "labels" : { "foo" : "bar" },
    "instance_owners" : "ariadna.fernandez@datatonic.com" # In runtime notebooks we need a string
    "metadata" : {}
    "access_type": "SERVICE_ACCOUNT"
    "type": "runtime-notebook"
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
