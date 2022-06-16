resource "google_storage_bucket" "bucket" {
  name                        = var.gcs_bucket_name
  project                     = var.project
  location                    = var.region
  labels                      = var.gcs_labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "postscript" {
  name   = "post_startup_script.sh"
  source = "${path.module}/bootstrap_files/post_startup_script.sh"
  bucket = google_storage_bucket.bucket.name
}
