# terraform backend full
```
terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket-12345"
    key            = "app/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
```
# use partial config only

## backend.hcl
```
bucket         = "my-terraform-backend-bucket-12345"
region         = "us-east-1"
dynamodb_table = "terraform-state-lock"
encrypt        = true
```

Partial configuration. The other settings (e.g., bucket, region) will be passed in from a file via -backend-config arguments to 'terraform init'

```
terraform {
  backend "s3" {
    key = "app/dev/terraform.tfstate"
  }
}
```

Run terraform init using backend-config

```
terraform init -backend-config=backend.hcl
```

# Isolating different environments 
- Put the Terraform configuration files for each environment into a separate folder. For example, all of the configurations for the staging environment can be in a folder called stage and all the configurations for the production environment can be in a folder called prod.
- Configure a different backend for each environment, using different authentication mechanisms and access controls: e.g., each environment could live in a separate AWS account with a separate S3 bucket as a backend.
- Use separate Terraform folders (and therefore separate state files) for each environment (staging, production, etc.) and for each component (VPC, services, databases) within that environment.


