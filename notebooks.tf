resource "google_workbench_instance" "notebook_instance" {
  for_each = var.notebooks

  project = var.project

  name         = each.key
  location     = var.zone

  gce_setup {
    disable_public_ip = true

    network_interfaces {
      network      = google_compute_network.vpc_network.id
      subnet       = google_compute_subnetwork.vertex-subnetwork.id
    }
  
    service_accounts {
      email = google_service_account.vertex_service_account.email
    } 

    metadata = {
      terraform                  = lookup(each.value["metadata"], "terraform", "true")
      notebook-disable-root      = lookup(each.value["metadata"], "notebook-disable-root", "true")
      notebook-disable-downloads = lookup(each.value["metadata"], "notebook-disable-downloads", "true")
      notebook-disable-nbconvert = lookup(each.value["metadata"], "notebook-disable-nbconvert", "true")
      report-system-health       = lookup(each.value["metadata"], "report-system-health", "true")
    }

    machine_type = lookup(each.value, "machine_type", var.machine_type)

    boot_disk {
      # Data & Storage
      disk_type    = lookup(each.value, "boot_disk_type", var.boot_disk_type)
      disk_size_gb = lookup(each.value, "boot_disk_size_gb", var.boot_disk_size_gb)  
    }

    data_disks {
      # data_disk_type      = lookup(each.value, "data_disk_type", var.data_disk_type)
      # Disabled for now https://github.com/hashicorp/terraform-provider-google/issues/8485
      disk_size_gb   = lookup(each.value, "data_disk_size_gb", var.data_disk_size_gb)
    }

  # GPUs
    dynamic "accelerator_configs" {
      for_each = lookup(each.value, "accelerator_type", var.accelerator_type) == "ACCELERATOR_TYPE_UNSPECIFIED" ? [] : [1]
      content {
        type       = lookup(each.value, "accelerator_type", var.accelerator_type)
        core_count = lookup(each.value, "accelerator_core_count", var.accelerator_core_count)
      }
    }
  }

# TODO check labels format
  # labels = {
  #   k = lookup(each.value, "nb_labels", null)
  # } 

  instance_owners = [lookup(each.value, "instance_owner", null)]

  depends_on = [
    google_service_account.vertex_service_account,
    google_compute_network.vpc_network,
    google_compute_subnetwork.vertex-subnetwork
  ]
}
