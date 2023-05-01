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

# Use output variables from one state to another
In project1, you can access the output variable of project2 using data.terraform_remote_state:
- Project 2 state and output variable
```
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "project2/terraform.tfstate"
    region = "us-east-1"
  }
}

output "example_output" {
  value = "example-value"
}


```
- Read values of output in project 2 in project 1.

```
data "terraform_remote_state" "project2" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bucket"
    key    = "project2/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = merge(
    var.tags,
    {
      "example_output" = data.terraform_remote_state.project2.outputs.example_output
    }
  )
}

```


