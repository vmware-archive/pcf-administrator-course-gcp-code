These terraform scripts are modified from the original source,
available at [https://github.com/pivotal-cf/terraforming-gcp](https://github.com/pivotal-cf/terraforming-gcp).

To use, create a `terraform.tfvars` file with the following variables:

```
project =
region =
zones = []
env_name =
opsman_image_url =
dns_suffix =
ssl_cert =
ssl_cert_private_key =
service_account_key =
```

Verify everything is setup correctly with: `terraform plan`
Create cloud resources: `terraform apply`
