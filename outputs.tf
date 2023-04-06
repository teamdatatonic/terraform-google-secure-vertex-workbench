# VPC Outputs

output "vpc_id" {
  description = "an identifier for the VPC network with format projects/{{project}}/global/networks/{{name}}"
  value       = google_compute_network.vpc_network.id
}

output "vpc_self_link" {
  description = "The URI of the created VPC."
  value       = google_compute_network.vpc_network.self_link
}

output "subnetwork_id" {
  description = "an identifier for the VPC subnetwork with format projects/{{project}}/regions/{{region}}/subnetworks/{{name}}"
  value       = google_compute_subnetwork.vertex-subnetwork.id
}

output "subnetwork_self_link" {
  description = "The URI of the created subnetwork."
  value       = google_compute_subnetwork.vertex-subnetwork.self_link
}

output "private_ip_alloc_id" {
  description = "an identifier for the private ip allocation with format projects/{{project}}/global/addresses/{{name}}"
  value       = google_compute_global_address.private_ip_alloc.id
}

output "private_ip_self_link" {
  description = "The URI of the created IP address."
  value       = google_compute_global_address.private_ip_alloc.self_link
}

# NAT Outputs

output "router_id" {
  description = "an identifier for the router with format projects/{{project}}/regions/{{region}}/routers/{{name}}"
  value       = google_compute_router.router.id
}

output "router_self_link" {
  description = "The URI of the created router."
  value       = google_compute_router.router.self_link
}

output "nat_id" {
  description = "an identifier for the NAT with format {{project}}/{{region}}/{{router}}/{{name}}"
  value       = google_compute_router.router.id
}

# FW Rules Outputs
output "firewall_id" {
  description = "an identifier for the fw rules with format projects/{{project}}/global/firewalls/{{name}}"
  value = {
    for k, rule in google_compute_firewall.fw_rules : k => rule.id
  }
}

# DNS Outputs
output "dns_policy_id" {
  description = "an identifier for the dns policy with format projects/{{project}}/policies/{{name}}"
  value       = google_dns_response_policy.pga-response-policy.id
}

output "googleapis-response-policy-rule_id" {
  description = "an identifier for the googleapis dns policy rule with format projects/{{project}}/responsePolicies/{{response_policy}}/rules/{{rule_name}}"
  value       = google_dns_response_policy_rule.googleapis-response-policy-rule-cname.id
}

output "gcr-response-policy-rule_id" {
  description = "an identifier for the gcr dns policy rule with format projects/{{project}}/responsePolicies/{{response_policy}}/rules/{{rule_name}}"
  value       = google_dns_response_policy_rule.gcr-response-policy-rule-cname.id
}

output "pkg-response-policy-rule_id" {
  description = "an identifier for the pkg.dev dns policy rule with format projects/{{project}}/responsePolicies/{{response_policy}}/rules/{{rule_name}}"
  value       = google_dns_response_policy_rule.pkg-dev-response-policy-rule-cname.id
}

output "notebooks-response-policy-rule_id" {
  description = "an identifier for the notebooks dns policy rule with format projects/{{project}}/responsePolicies/{{response_policy}}/rules/{{rule_name}}"
  value       = google_dns_response_policy_rule.notebooks-response-policy-rule-cname.id
}

# GCS Bucket Outputs

output "gcs_bucket_self_link" {
  description = "The URI of the created bucket."
  value       = google_storage_bucket.bucket.self_link
}

output "gcs_bucket_url" {
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
  value       = google_storage_bucket.bucket.url
}

# Notebooks Outputs

output "user_managed_notebook_id" {
  description = "an identifier for the notebooks with format projects/{{project}}/global/firewalls/{{name}}"
  value = {
    for k, nb in google_notebooks_instance.notebook_instance : k => nb.id
  }
}

output "runtime_notebook_id" {
  description = "an identifier for the notebooks with format projects/{{project}}/global/firewalls/{{name}}"
  value = {
    for k, nb in google_notebooks_runtime.runtime_notebook_instance : k => nb.id
  }
}