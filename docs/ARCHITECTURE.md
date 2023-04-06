# Architecture

## Introduction

The following design is built in this terraform module:


![Notebook/Network Archietcture ](./images/private-notebooks.png "Notebook/Network Architecture")


In order to provision fully-functioning private, secure Vertex AI User-Managed Notebooks, the following resources must be deployed:

### Custom VPC & Subnet

A custom-mode VPC network needs to be created, along with a Vertex Subnet, which has ```Private Google Access``` enabled. This is the subnet in which the notebooks will reside.

### DNS

In order to facilitate private access with Google Service APIs we must establish private DNS rules that avoid using Google's public IP ranges.
DNS policies will route calls from GCP API's such as ```googleapis.com```  to either ```restricted.googleapis.com``` or ```private.googleapis.com`` which is more secure. 

**NOTE**: The Restricted Google API CIDR (```restricted.googleapis.com```) is used when [VPC Service Controls](https://cloud.google.com/vpc-service-controls) are in operation in your environment, while the Private Google API CIDR (```private.googleapis.com``) is used when VPC Service Controls are not in operation. In this module, this is flagged by the ```vpc_sc_enabled``` variable.

To implement DNS we will use ***DNS Response Policies*** which offers more flexibility over traditional private DNS and is easier to configure.

The DNS policy applies to our custom-mode VPC metwork:

| Name               | Selector                 | Action       |
| ------------------ | ------------------------ | ------------ |
| ```googleapis```   | ```*.googleapis.com```   | Local data   |
| ```gcr.io```       | ```*.gcr.io```           | Local data   |
| ```pkg.dev```      | ```*.pkg.dev```          | Local data   |
| ```notebooks```    | ```*.notebooks.cloud.google.com```| Local data   |

The majority of Google API's are served from ```*.googleapis.com```. We've also added entries for Container Registry (required as part of the Notebook startup script) ```*.gcr.io``` and Artfact Registry ```*.pkg.dev```. We have also added entries for the ```notebooks.cloud.google.com``` domain, as this is required as part of the Notebook startup script, where a proxy is registered.

#### Local Data Definition

For ```restricted.googleapis.com``` this looks like:

| DNS Name                | Type | TTL    | Data |
| ----------------------  | ---- | ------ | --------- |
| ```*.googleapis.com```  | A    | 3600   | 199.36.153.4, 199.36.153.5, 199.36.153.6, 199.36.153.7 |

and for ```private.googleapis.com`` this looks like:

| DNS Name                | Type | TTL    | Data |
| ----------------------  | ---- | ------ | --------- |
| ```*.googleapis.com```  | A    | 3600   | 199.36.153.8, 199.36.153.9, 199.36.153.10, 199.36.153.11 |


### Firewall Rules

In summary, the following Firewall Rules are provisioned:

| FW Rule Name | Direction | Priority | Ranges | Description |
|--------------|-----------|----------|--------|-------------|
| ingress-allow-tcp-git | ingress | 65534 | GitHub Endpoints | Allows access from Notebooks to Github - see https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses for more info |
| egress-allow-tcp-git | egress | 65534 | GitHub Endpoints | Same as above ^ |
| egress-deny-all | egress | 65535 | 0.0.0.0/0 | Blanket default deny on internet traffic with lowest priority|
| ingress-allow-tcp-ssh-from-iap | ingress | 65534 | 35.235.240.0/20 | Allows IAP SSH access to VMs, which is useful for debugging |
| egress-allow-private-gcp-services | egress | 65534 | 199.36.153.8/30 | Allows access to private Google API endpoints |
| egress-allow-restricted-gcp-services | egress | 65534 | 199.36.153.4/30 | Allows access to restricted Google API endpoints |
| egress-allow-fastly-cdn-for-pypi | egress | 65534 | Fastly CDN - used by PyPi | Allows access from Notebooks to PyPi to install Python libraries |

These FW Rules deny all internet traffic, except for required IPs (eg. for GitHub or PyPi). If a user wanted to access other services from their notebooks, they would simply need to specifify it in ```additional_fw_rules``` - see the example for how this is done.

### Routes

In order for the notebooks to be able to reach the private/restricted googleapis endpoints, as well as allow for some limited internet access, the following Routes are required for our VPC:

| Route Name | Destination | Next Hop Gateway |
|------------|-------------|------------------|
| private-googleapis | 199.36.153.8/30 | default-internet-gateway |
| restricted-googleapis | 199.36.153.4/30 | default-internet-gateway |
| default-internet-gw | 0.0.0.0/0 | default-internet-gateway |

### Cloud NAT

Cloud NAT is used to allow the Vertex AI Notebooks with only internal IP to communicate with the public internet. This connectivity to the public internet is limited by the firewall rules described above, meaning that only whitelisted IPs can communicate with the notebooks.

The Cloud NAT is limited to usage only within our Vertex subnetwork, in order to fully limit the exposure of our VPC to the internet.

A Cloud Router is also deployed here as a prerequisit to using the Cloud NAT.

### Notebooks

The Vertex AI User-Managed Notebooks are deployed with internal IP only, along with a Service Account which is used on the Notebook, with some default roles attached for basic Notebook useage.
An example of how to configure the notebooks can be found in the example.


### GCS Bucket & Script

A GCS bucket is created and a post-startup script is written to it, which is then used by the notebooks.
The script is responsible for implementing two security features (```disable_nbconvert``` and ```disable_downloads```), as they are not configurable via the terraform resource at present.
See the script in the [bootstrap_files](../bootstrap_files/) folder.
