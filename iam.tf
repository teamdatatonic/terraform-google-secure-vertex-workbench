locals {
  default_vertex_nb_sa_roles = [
    "roles/aiplatform.user",
    "roles/iam.serviceAccountUser",
    "roles/bigquery.jobUser",
    "roles/bigquery.user",
    "roles/bigquery.dataEditor",
    "roles/bigquery.dataOwner",
    "roles/storage.admin",
    "roles/storage.objectAdmin",
    "roles/logging.admin",
    "roles/artifactregistry.admin",
    "roles/notebooks.admin"
  ]
  vertex_nb_sa_roles = concat(local.default_vertex_nb_sa_roles, var.additional_vertex_nb_sa_roles)
}

resource "google_service_account" "vertex_service_account" {
  project      = var.project
  account_id   = "vertex-nb-sa"
  display_name = "Vertex User Managed Service Account"
}

resource "google_project_iam_member" "vertex_nb_sa" {
  for_each = toset(local.vertex_nb_sa_roles)
  project  = var.project
  role     = each.key
  member   = "serviceAccount:${google_service_account.vertex_service_account.email}"
  depends_on = [
    google_service_account.vertex_service_account
  ]
}