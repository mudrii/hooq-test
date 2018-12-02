## Creating back-end storage for tfstate file in AWS S3

Once we have terraform IAM account created we can proceed to next step creating dedicated bucket to keep terraform state files

### Create terraform state bucket

> NOTE: Change name of the bucker, name should be unique across all AWS S3 buckets

```sh
aws s3 mb s3://hooq.terra-state-bucket --region us-west-2
```

### Enable versioning on the newly created bucket

```sh
aws s3api put-bucket-versioning --bucket hooq.terra-state-bucket --versioning-configuration Status=Enabled
```



# ECS with ALB example

This example shows how to launch an ECS service fronted with Application Load Balancer.

The example uses latest CoreOS Stable AMIs.

To run, configure your AWS provider as described in https://www.terraform.io/docs/providers/aws/index.html

## Get up and running

Planning phase

```
terraform plan \
	-var admin_cidr_ingress='"{your_ip_address}/32"' \
	-var key_name={your_key_name}
```

Apply phase

```
terraform apply \
	-var admin_cidr_ingress='"{your_ip_address}/32"' \
	-var key_name={your_key_name}
```

Once the stack is created, wait for a few minutes and test the stack by launching a browser with the ALB url.

## Destroy :boom:

```
terraform destroy
```
