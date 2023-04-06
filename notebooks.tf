locals {
  runtime_notebooks = {
    for notebook, values in var.notebooks : notebook => values
    if values.type == "runtime-notebook"
  }
  user_managed_notebooks = {
    for notebook, values in var.notebooks : notebook => values
    if values.type == "user-managed-notebook"
  }
}


resource "google_notebooks_instance" "notebook_instance" {
  for_each = local.user_managed_notebooks

  project = var.project

  name         = each.key
  location     = var.zone
  network      = google_compute_network.vpc_network.id
  subnet       = google_compute_subnetwork.vertex-subnetwork.id
  no_public_ip = true

  labels = lookup(each.value, "nb_labels", null)

  instance_owners = lookup(each.value, "instance_owners", null)

  service_account = google_service_account.vertex_service_account.email

  metadata = {
    terraform                  = lookup(each.value["metadata"], "terraform", "true")
    notebook-disable-root      = lookup(each.value["metadata"], "notebook-disable-root", "true")
    notebook-disable-downloads = lookup(each.value["metadata"], "notebook-disable-downloads", "true")
    notebook-disable-nbconvert = lookup(each.value["metadata"], "notebook-disable-nbconvert", "true")
    report-system-health       = lookup(each.value["metadata"], "report-system-health", "true")
  }
  post_startup_script = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.postscript.name}"


  machine_type = lookup(each.value, "machine_type", var.machine_type)
  vm_image {
    project      = lookup(each.value, "image_project", var.image_project)
    image_family = lookup(each.value, "image_family", var.image_family)
  }

  # Data & Storage
  boot_disk_type    = lookup(each.value, "boot_disk_type", var.boot_disk_type)
  boot_disk_size_gb = lookup(each.value, "boot_disk_size_gb", var.boot_disk_size_gb)
  # data_disk_type      = lookup(each.value, "data_disk_type", var.data_disk_type)
  # Disabled for now https://github.com/hashicorp/terraform-provider-google/issues/8485
  data_disk_size_gb   = lookup(each.value, "data_disk_size_gb", var.data_disk_size_gb)
  no_remove_data_disk = lookup(each.value, "no_remove_data_disk", var.no_remove_data_disk)

  # GPUs
  install_gpu_driver = lookup(each.value, "install_gpu_driver", var.install_gpu_driver)
  dynamic "accelerator_config" {
    for_each = lookup(each.value, "accelerator_type", var.accelerator_type) == "ACCELERATOR_TYPE_UNSPECIFIED" ? [] : [1]
    content {
      type       = lookup(each.value, "accelerator_type", var.accelerator_type)
      core_count = lookup(each.value, "accelerator_core_count", var.accelerator_core_count)
    }
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      create_time,
      update_time,
    ]
  }
  depends_on = [
    google_service_account.vertex_service_account,
    google_compute_network.vpc_network,
    google_compute_subnetwork.vertex-subnetwork
  ]
}


resource "google_notebooks_runtime" "runtime_notebook_instance" {

  for_each = local.runtime_notebooks

  name     = each.key
  location = var.region
  project  = var.project

  access_config {
    access_type   = lookup(each.value, "access_type", var.access_type)
    runtime_owner = var.access_type == "SINGLE_USER" ? lookup(each.value, "instance_owners", null) : (var.access_type == "SERVICE_ACCOUNT" ? google_service_account.vertex_service_account.email : null) #TODO: this statement is not working properly
  }

  software_config {
    post_startup_script = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.postscript.name}"
    install_gpu_driver  = lookup(each.value, "install_gpu_driver", var.install_gpu_driver)
  }

  virtual_machine {
    virtual_machine_config {
      machine_type = lookup(each.value, "machine_type", var.machine_type)
      labels       = lookup(each.value, "nb_labels", null)
      metadata = {
        terraform                  = lookup(each.value["metadata"], "terraform", "true")
        notebook-disable-root      = lookup(each.value["metadata"], "notebook-disable-root", "true")
        notebook-disable-downloads = lookup(each.value["metadata"], "notebook-disable-downloads", "true")
        notebook-disable-nbconvert = lookup(each.value["metadata"], "notebook-disable-nbconvert", "true")
        report-system-health       = lookup(each.value["metadata"], "report-system-health", "true")
      }
      network          = google_compute_network.vpc_network.id
      subnet           = google_compute_subnetwork.vertex-subnetwork.id
      internal_ip_only = true
      data_disk {
        initialize_params {
          disk_size_gb = lookup(each.value, "data_disk_size_gb", var.data_disk_size_gb)
          disk_type    = lookup(each.value, "boot_disk_type", var.boot_disk_type)
        }
      }
      accelerator_config {
        core_count = lookup(each.value, "accelerator_core_count", var.accelerator_core_count)
        type       = lookup(each.value, "accelerator_type", "NVIDIA_TESLA_P100")
      }
    }
  }

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [
    google_compute_network.vpc_network,
    google_compute_subnetwork.vertex-subnetwork
  ]
}
