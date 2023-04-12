# Terraform Private Vertex AI Workbench Notebooks Module

This module deploys [Vertex AI Workbench User-Managed Notebooks](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/introduction) and [Vertex AI Workbench Managed Notebooks](https://cloud.google.com/vertex-ai/docs/workbench/managed/introduction) on GCP that are private (interal IP only), while still remaining easily usable and accessible by the user of the notebook.

## Introduction

User-Managed and Managed Notebooks on Vertex AI allow users to easily deploy GCE VMs with JupyterLab pre-installed. These VMs, by default, use external IP in order to spin up the instance (by running startup scripts), as well as to actually use the Jupyter notebook, such as installing Python libraries from PyPi or interacting with GitHub.

The problem with this is the security issue that arises with external IP. GCE VM Security best practice states that VMs should not have an external IP assigned to it, unless absolutely necessary, as it opens the instance up to attack from the public internet. Therefore, by default, Vertex AI User-Managed Notebooks are, by default, vulnerable to attach from the public internet too.

This Terraform module is the answer to this problem. The security and networking configuration that the Vertex Notebooks in this module use allows the Notebooks to be deployed with only internal IP (no external IP), while still maintaining the useability and accessibility (ie. can be still accessed directly via the GCP Vertex Workbench GUI by clicking the 'OPEN JUPYTERLAB' button).


## Architecture

The following Notebook/Network Architecture is deployed in this module:


![Notebook/Network Archietcture ](./docs/images/private-notebooks.png "Notebook/Network Architecture")


For more information about each component of this design, please refer to [ARCHITECTURE.md](./docs/ARCHITECTURE.md)

## Development

### Local setup

- Install [pre-commit](https://pre-commit.com/)
- Install the pre-commit hooks - `pre-commit install`

### README

The README file is autogenerated using [`terraform-docs`](https://github.com/terraform-docs/terraform-docs). This is done when you create a pull request (or push to an existing PR).

You can customise the template (including this text for example) in `.github/workflows/pr-checks.yml`.

## Usage

There is an example of how to use this module in the [example](./example/) folder but simple usage is as follows:

```hcl
module "private_vertex_nb_instances" {
  source                        = "<LINK TO MODULE SOURCE>"
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
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 0.14.5 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 0.14.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 0.14.5 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 0.14.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_dns_response_policy.pga-response-policy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy) | resource |
| [google-beta_google_dns_response_policy_rule.gcr-response-policy-rule-a](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.gcr-response-policy-rule-cname](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.googleapis-response-policy-rule-cname](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.notebooks-response-policy-rule-a](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.notebooks-response-policy-rule-cname](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.pkg-dev-response-policy-rule-a](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.pkg-dev-response-policy-rule-cname](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google-beta_google_dns_response_policy_rule.priv-googleapis-response-policy-rule-a](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
| [google_compute_firewall.fw_rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.private_ip_alloc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_route.default_internet_gateway](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_route.private_googleapis_ips](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_route.restricted_googleapis_ips](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.vertex-subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_notebooks_instance.notebook_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/notebooks_instance) | resource |
| [google_notebooks_runtime.runtime_notebook_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/notebooks_runtime) | resource |
| [google_project_iam_member.vertex_nb_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.vertex_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_networking_connection.service_peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.postscript](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_core_count"></a> [accelerator\_core\_count](#input\_accelerator\_core\_count) | Count cores of accelerator. | `number` | `1` | no |
| <a name="input_accelerator_type"></a> [accelerator\_type](#input\_accelerator\_type) | Type of accelerator. Possible values are ACCELERATOR\_TYPE\_UNSPECIFIED, NVIDIA\_TESLA\_K80, NVIDIA\_TESLA\_P100, NVIDIA\_TESLA\_V100, NVIDIA\_TESLA\_P4, NVIDIA\_TESLA\_T4, NVIDIA\_TESLA\_T4\_VWS, NVIDIA\_TESLA\_P100\_VWS, NVIDIA\_TESLA\_P4\_VWS, NVIDIA\_TESLA\_A100, TPU\_V2, and TPU\_V3 | `string` | `"ACCELERATOR_TYPE_UNSPECIFIED"` | no |
| <a name="input_access_type"></a> [access\_type](#input\_access\_type) | Access type for Runtime Notebooks. Possible values are SINGLE\_USER, SERVICE\_ACCOUNT and RUNTIME\_ACCESS\_TYPE\_UNSPECIFIED | `string` | `"SINGLE_USER"` | no |
| <a name="input_additional_fw_rules"></a> [additional\_fw\_rules](#input\_additional\_fw\_rules) | Additional firewall rules that you may want to create to allow other traffic | `list(any)` | `[]` | no |
| <a name="input_additional_vertex_nb_sa_roles"></a> [additional\_vertex\_nb\_sa\_roles](#input\_additional\_vertex\_nb\_sa\_roles) | Additional roles that you may want to assign to the Vertex AI NB SA | `list(any)` | `[]` | no |
| <a name="input_boot_disk_size_gb"></a> [boot\_disk\_size\_gb](#input\_boot\_disk\_size\_gb) | The size of the boot disk in GB attached to notebook instances, up to a maximum of 64 TB. The minimum recommended value is 100GB. | `number` | `100` | no |
| <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type) | Boot disk type for notebook instances. Possible values are DISK\_TYPE\_UNSPECIFIED, PD\_STANDARD, PD\_SSD and PD\_BALANCED | `string` | `"PD_STANDARD"` | no |
| <a name="input_data_disk_size_gb"></a> [data\_disk\_size\_gb](#input\_data\_disk\_size\_gb) | The size of the data disk in GB attached to notebook instances, up to a maximum of 64 TB. You can choose the size of the data disk based on how big your notebooks and data are. | `number` | `100` | no |
| <a name="input_gcs_bucket_name"></a> [gcs\_bucket\_name](#input\_gcs\_bucket\_name) | Name of the GCS Bucket that will contain the post startup script | `string` | n/a | yes |
| <a name="input_gcs_labels"></a> [gcs\_labels](#input\_gcs\_labels) | Labels to attach to the GCS Bucket. Useful for labelling resources for billing purposes | `map(string)` | `null` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Image family for the Notebook instances (https://cloud.google.com/compute/docs/images) | `string` | `"common-cpu"` | no |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | GCP Project conataining VM image for the Notebook instances | `string` | `"deeplearning-platform-release"` | no |
| <a name="input_install_gpu_driver"></a> [install\_gpu\_driver](#input\_install\_gpu\_driver) | Whether the end user authorizes Google Cloud to install GPU driver on this instance. If this field is empty or set to false, the GPU driver won't be installed. Only applicable to instances with GPUs. | `string` | `false` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The Notebook Instance's machine type | `string` | `"n1-standard-4"` | no |
| <a name="input_no_remove_data_disk"></a> [no\_remove\_data\_disk](#input\_no\_remove\_data\_disk) | If true, the data disk will not be auto deleted when deleting the instance. | `bool` | `true` | no |
| <a name="input_notebooks"></a> [notebooks](#input\_notebooks) | A map containing the containing the configuration for the desired Vertex AI Workbench User-Managed Notebooks | `any` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Your GCP Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the GCS bucket and Artifact Registry | `string` | `"europe-west1"` | no |
| <a name="input_subnet_ip_cidr_range"></a> [subnet\_ip\_cidr\_range](#input\_subnet\_ip\_cidr\_range) | The name of your VPC Subnetwork | `string` | `"10.0.0.0/21"` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of your VPC Network | `string` | n/a | yes |
| <a name="input_vpc_sc_enabled"></a> [vpc\_sc\_enabled](#input\_vpc\_sc\_enabled) | A boolean flag to signal whether this enviornment is inside a VPC SC Perimeter | `bool` | `false` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The GCP Zone for Vertex Notebook User-Managed Instances | `string` | `"europe-west1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_policy_id"></a> [dns\_policy\_id](#output\_dns\_policy\_id) | an identifier for the dns policy with format projects/{{project}}/policies/{{name}} |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | an identifier for the fw rules with format projects/{{project}}/global/firewalls/{{name}} |
| <a name="output_gcr-response-policy-rule_id"></a> [gcr-response-policy-rule\_id](#output\_gcr-response-policy-rule\_id) | an identifier for the gcr dns policy rule with format projects/{{project}}/responsePolicies/{{response\_policy}}/rules/{{rule\_name}} |
| <a name="output_gcs_bucket_self_link"></a> [gcs\_bucket\_self\_link](#output\_gcs\_bucket\_self\_link) | The URI of the created bucket. |
| <a name="output_gcs_bucket_url"></a> [gcs\_bucket\_url](#output\_gcs\_bucket\_url) | The base URL of the bucket, in the format gs://<bucket-name> |
| <a name="output_googleapis-response-policy-rule_id"></a> [googleapis-response-policy-rule\_id](#output\_googleapis-response-policy-rule\_id) | an identifier for the googleapis dns policy rule with format projects/{{project}}/responsePolicies/{{response\_policy}}/rules/{{rule\_name}} |
| <a name="output_nat_id"></a> [nat\_id](#output\_nat\_id) | an identifier for the NAT with format {{project}}/{{region}}/{{router}}/{{name}} |
| <a name="output_notebooks-response-policy-rule_id"></a> [notebooks-response-policy-rule\_id](#output\_notebooks-response-policy-rule\_id) | an identifier for the notebooks dns policy rule with format projects/{{project}}/responsePolicies/{{response\_policy}}/rules/{{rule\_name}} |
| <a name="output_pkg-response-policy-rule_id"></a> [pkg-response-policy-rule\_id](#output\_pkg-response-policy-rule\_id) | an identifier for the pkg.dev dns policy rule with format projects/{{project}}/responsePolicies/{{response\_policy}}/rules/{{rule\_name}} |
| <a name="output_private_ip_alloc_id"></a> [private\_ip\_alloc\_id](#output\_private\_ip\_alloc\_id) | an identifier for the private ip allocation with format projects/{{project}}/global/addresses/{{name}} |
| <a name="output_private_ip_self_link"></a> [private\_ip\_self\_link](#output\_private\_ip\_self\_link) | The URI of the created IP address. |
| <a name="output_router_id"></a> [router\_id](#output\_router\_id) | an identifier for the router with format projects/{{project}}/regions/{{region}}/routers/{{name}} |
| <a name="output_router_self_link"></a> [router\_self\_link](#output\_router\_self\_link) | The URI of the created router. |
| <a name="output_runtime_notebook_id"></a> [runtime\_notebook\_id](#output\_runtime\_notebook\_id) | an identifier for the notebooks with format projects/{{project}}/global/firewalls/{{name}} |
| <a name="output_subnetwork_id"></a> [subnetwork\_id](#output\_subnetwork\_id) | an identifier for the VPC subnetwork with format projects/{{project}}/regions/{{region}}/subnetworks/{{name}} |
| <a name="output_subnetwork_self_link"></a> [subnetwork\_self\_link](#output\_subnetwork\_self\_link) | The URI of the created subnetwork. |
| <a name="output_user_managed_notebook_id"></a> [user\_managed\_notebook\_id](#output\_user\_managed\_notebook\_id) | an identifier for the notebooks with format projects/{{project}}/global/firewalls/{{name}} |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | an identifier for the VPC network with format projects/{{project}}/global/networks/{{name}} |
| <a name="output_vpc_self_link"></a> [vpc\_self\_link](#output\_vpc\_self\_link) | The URI of the created VPC. |