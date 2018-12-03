# AWS infra with terraform

Terraform will create following infrastructure on AWS

* VPC
  * internet Gateway
  * 3 subnets
  * routing table
  * securety group for front end load balancer
  * securety group for front end nginx servers
  * securety group for back end load balancer
  * securety group for back end node.js servers
  * securety group for RDS postgreSQL
  * securety group for Elasticach Redis
* RDS PostgreSQL server
* Elasticach Redis cluster with 2 instances
* front end load balancer
* back end load balancer
* add 2 new ssh key's
* EC2 lunch configuration for front end nginx servers
* EC2 autoscaling group for front end nginx servers
* autoscaling polices for front end
  * mem scaling up
  * mem scaling down
  * cpu scaling up
  * cpu scaling down
* EC2 lunch configuration for back end node.js servers
* EC2 autoscaling group for back end node.js servers
* autoscaling polices for back end
  * mem scaling up
  * mem scaling down
  * cpu scaling up
  * cpu scaling down

> NOTE: terraform is using modules and workspaces

### Code staructure 

```sh
.
├── back_end_data.sh
├── backend.tf
├── compute
│   ├── autoscaling
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ec2_keys
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── elb
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── elasticache
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── front_end_data.sh
├── key_sha_back
├── key_sha_back.pub
├── key_sha_front
├── key_sha_front.pub
├── main.tf
├── network
│   ├── route
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sec_groups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── subnets
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── rds
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── README.md
├── terraform.tfvars
└── variables.tf
```

## Creating back-end storage for tfstate file in AWS S3

### Create terraform state bucket

> NOTE: Change name of the bucker, name should be unique across all AWS S3 buckets

```sh
aws s3 mb s3://hooq.terra-state-bucket --region us-west-2
```

### Enable versioning on the newly created bucket

```sh
aws s3api put-bucket-versioning --bucket hooq.terra-state-bucket --versioning-configuration Status=Enabled
```

### Initialize and pull terraform cloud specific dependencies

```sh
terraform init
```

#### Create dev workspace

```sh
terraform workspace new dev
```

#### List available workspace

```sh
terraform workspace list
```

#### Select dev workspace

```sh
terraform workspace select dev
```

> NOTE Before we can start will need to add variables like access_key, secret_key db password to terraform.tfvars

Example of terraform.tfvars

```sh
access_key = "AZIAIEOU86I3YWYW5JDSQP4Q"
secret_key = "oInx5R4q5LqYVSjVdQ4effdhzEfRiFAcQYAULC8b"
db_password = "mydbpassword."
key_sha_front = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoJFEXgapKdfQZURhgLCy6tJ6yHljpcsYm1E1EgpC7wbj0CvDV0mwpsKIbxw6ERxsng3zXT4stDSks6k2sQQccWZIUdL88EETWvsCIM+3m24GUeU2PJIwXCyzfOsxAwm8BqmnqXlLncxz8uM0ta1Ydy4GadJ6KZOO3hGp/I2lXYJCuFyU7exwv4EMSFhQwJ/ogHFvq67VJz8Mw6jVrl6jQm+YnO052LwE40F3sCdRSmjGl9ufDLG3gAgz594FtVYtwhpURx9a961WjoLfeMLQ8x3/027Bp1dy0zKf52D9wTXVUKhiegwCVFWjl7WH/9dFlElNc2dr4A5LIXArRybYosDXvCmIKmQ2Bq/QDRQPN2B6O/8c4X+B4AjIOoHDjKEQbSj9yTen7+KUhXzf1w8/ZfL62/AblNAX5eSQSl2xBLiVH7pROlB64Jw1FMAX1Hb6DPxtNRA2B3xrbjel2af80nEYhbqrgYUHvhk4LrzLWWH7Vh9tP4ge5BnEHv/Xn3aH+p+rPWU8Byo9gwRAe9evXAHs5cxpaR2hawvoRxB/8Zau5wls2B1a8ZfwurBDlKPpK1Sfm6vJqLv9/kRfq+PYxAgy8DJbRq2aZvXt28saUsjVf8qe1d1ioHn/9k1f5wdYv7ugqlcMAs9gwEkN9AK0+JgQs+Iogce3f2YOWo64S8Q== mudrii@linux"
key_sha_back = "ssh-rsa AAAAB3NzaC1y1EAAAADAQABAAACAQDmEOXqi1BwOjksXb2dOyJjfC5gFDGcgJuPa1ywwd6hkxQgN8vSxXsCG8/IG8MrI9k16vvAICqOJWnYCnk1Sz6DyEPi2tPsqrhhChLnvWPPBsl4rcReBIqe0xaX3sbfHrB1CeGZx1jifpLtzkJ6LnvefMfEeDAGrart1uk7zJyw2tCApGa7cSrq4MCCJlJgIB1DpGY1h45pQL8CjA6ujJSvO5DdgxKpyHnGejdHOrA7abBSg9l7OYMfVBfSX76YWYPsKXCehyGfRMbYsQSpiYZVHS/Reni9PYXcs1I5HysQLlGue00yt3H4X3bFNwlU8uCNxbmsdnAqciZV78YFsqletxWX0x/MxtEbKD+6dH6T/3A8tVRM7sbybEg5Q8TjcUKAjLYwv0VVcXgCPs0/ebZsflvRIoKj5Ng5mEyqaMAkpz6+QCoBj9yXGAOovIQhW1nv+ebrW5H8qzUh8iTi3N7OT4Smc3qhLJ0+dAcBFhR+aFEHzdi7oRW7rimwUPmEXzqRXTlQLosrry6X9r0VwnbPDlwnQKkzzhR2KyLnACFYCsRg46qNugVVwP5QQSlOKLflj382coO1ggVketSJNUptxmOcYjjbStPe0M9KNdTeRCXfnUnytYJ5BkExeKPt+pbjZolQBkcbtBJpEVbkPULWE2nNB2I2u6HGISU1rnTWCq== mudrii@linux"
```

Q&A
The size of CPU and memory required to run this stack. Explain why.

* Nginx 4 vCPU and 16Gb RAM as is highly efficient http/reverse proxy server, dependent on type of the content is caching can be configured with multiple workers. If Nginx is running in docker container recommendation to link nginx container directly to host network interface Ex. " docker run --net=host -d nginx"
* Node.js assuming we running one container per ec2 instance Node is single threaded recommendation is 2 vCPU with 16 Gb RAM.
* both nginx and node.js can be scaled horizontally with aws ec2 autoscaling.
  * nginx scale based on RAM
  * node.js scale mostly based on CPU

What is the potential bottleneck

* Redis and DB should be properly provisioning. Depending on application how much rely on redis as cach or redis as user session manager. Same for DB is DB used for high I/O.

Suggest better approach, explain why.

* moving away from nginx as caching and using CloudFront CDN and store images in S3
* moving away from ECR and setting up Kubernetes as have better container management and more flexible in native k8s deployment Ex Spinnaker.

Clients can perform unintended “retry”, how will you anticipate that?

* using ELB sticky sessions
* using Redis as session cach
* using in app cockyes sessions.

Test: write down an instruction on how to test your solution.

* few solution available to test performance of the application and infrastructure.
* once approach would be to use jmeter
* Saas optionavalable like BlazeMeter
* Saas solution for monitoring app like datadog and new relic

You are tasked to find out on how many connections on each database host.

* Assuming we are running PostgreSQL

```sql
select  * from
(select count(*) used from pg_stat_activity) q1,
(select setting::int res_for_super from pg_settings where name=$$superuser_reserved_connections$$) q2,
(select setting::int max_conn from pg_settings where name=$$max_connections$$) q3;
```

> NOTE pg_stat_activity gives all connections, regardless of user.

Return the most frequently-occuring IP

```sh
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" "${1:?}" | sort -n | uniq -c | sort -nr | head -10 |
while read IP
	do
    	echo "$IP"
done
```
