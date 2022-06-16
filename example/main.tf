module "private_vertex_nb_instances" {
  source                        = "../"
  project                       = var.project
  zone                          = var.zone
  region                        = var.region
  notebooks                     = var.notebooks
  additional_vertex_nb_sa_roles = var.additional_vertex_nb_sa_roles
  vpc_network_name              = var.vpc_network_name
  subnet_ip_cidr_range          = var.subnet_ip_cidr_range
  vpc_sc_enabled                = false
  gcs_bucket_name               = var.gcs_bucket_name
  gcs_labels                    = var.gcs_labels
  additional_fw_rules           = var.additional_fw_rules
}
