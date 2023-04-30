#!/bin/bash

# generate a random string of 6 digits
random=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | fold -w 6 | head -n 1)

# check if region is us-east-1
if [[ $1 == "us-east-1" ]]
then
  bucket_name="my-terraform-backend-bucket-$random"
  aws s3api create-bucket --bucket $bucket_name --region us-east-1
else
  bucket_name="my-terraform-backend-bucket-$random"
  aws s3api create-bucket --bucket $bucket_name --region $1 --create-bucket-configuration LocationConstraint=$1
fi

# create DynamoDB table
aws dynamodb create-table --table-name tf_locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PROVISIONED --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $1
