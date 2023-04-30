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
region         = "us-east-2"
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
