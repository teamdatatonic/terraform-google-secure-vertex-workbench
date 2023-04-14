resource "google_compute_network" "vpc_network" {
  project                         = var.project
  name                            = var.vpc_network_name
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "vertex-subnetwork" {
  name                     = "${var.vpc_network_name}-vertex-subnet"
  ip_cidr_range            = var.subnet_ip_cidr_range
  region                   = var.region
  project                  = var.project
  private_ip_google_access = true
  network                  = google_compute_network.vpc_network.id
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.vpc_network_name}-private-ip-alloc"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "service_peering" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_compute_route" "private_googleapis_ips" {
  name             = "private-googleapis"
  project          = var.project
  dest_range       = "199.36.153.8/30"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 100
}

resource "google_compute_route" "restricted_googleapis_ips" {
  name             = "restricted-googleapis"
  project          = var.project
  dest_range       = "199.36.153.4/30"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 100
}

resource "google_compute_route" "default_internet_gateway" {
  name             = "${google_compute_network.vpc_network.name}-default-internet-gw"
  project          = var.project
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}
