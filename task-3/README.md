# Task 2
## Task goal 
> Provide infrastructure and create CI/CD with a web app that will listen 8089 port and return "ReallyNotBad" string when POST request contains header "NotBad" with value "true", eg. `curl -X POST -H "NotBad: true" https://someurl:8089/` should return "ReallyNotBad".

---

## Part 1. App
Simple HTTP server is developed using NodeJS. 

App source code is located in [app/](https://github.com/antomer/nb-test-task/tree/master/task-3/app/) folder.

### Configuration
App reads and uses following environment variables: 

| ENV var name | required | default value | description                            |
|--------------|----------|---------------|----------------------------------------|
| PORT         | no       | 8089          | port on which server will be listening |
| LOGS_ENABLED | no       | true          | enable logs                            | 


### Testing
Server logic is tesed with unit tests located in [app/test/unit/](https://github.com/antomer/nb-test-task/tree/master/task-3/app/test/unit) folder.

To run test execute:
``` 
npm i && npm run test
```

### Run 
To run app you can either:
1. Execute it as a node process (requires NodeJS & npm to be installed locally)
    ```
    npm i && npm run start
    ```
2. Run container locally (requires to have container runtime installed locally)
    ```
    docker build -t nb-simple-service . && docker run -p 8089:8089 -it nb-simple-service 
    ```

### Build container image
App is packaged in container image and can be built using [app/Dockerfile](https://github.com/antomer/nb-test-task/tree/master/task-3/app/Dockerfile)

For example:
```
docker build -t nb-simple-service .
```

### Deployment
Deplyoment is done using GitHub action and is run automatically when code is merged to master. Helm is used to template deployment configuration and is located in [app/.deploy/helm](https://github.com/antomer/nb-test-task/tree/master/task-3/app/.deploy/helm) folder.

Service is currently deployed in AWS and can be accessed via http://35.158.175.96:8089



---

## Part 2. Infrastructure as Code
Infrastrucutre as Code is devloped using Terraform and deployed to free tier AWS account. Infrastructure source code is located in [infra/](https://github.com/antomer/nb-test-task/tree/master/task-3/infra/) folder.

### Pre requisites
Following pre-requisites are required to run terraform
1. AWS account https://aws.amazon.com/
2. AWS CLI is set up https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
3. Terraform CLI is installed locally https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### Module `init/`
In order to deploy main Terraform we need to provision s3 bucket to store terraform states and dynamoDB table to store terraform state locks. 
It is automated and can be done by [init script](https://github.com/antomer/nb-test-task/tree/master/task-3/infra/init/init.tf)

#### **How to apply**
1. make sure Pre requisites are fullfilled
2. From [infra/init](https://github.com/antomer/nb-test-task/tree/master/task-3/infra/init/) folder run following command:
    ```
    terraform init 
    terraform apply
    ```

#### **Variables**
[init script](https://github.com/antomer/nb-test-task/tree/master/task-3/infra/init/init.tf) has only two varaibles: 
 
| var name   | required | default value    | description                                                  |
|------------|----------|------------------|--------------------------------------------------------------|
| env_name   | no       | "nb-development" | environemnt name, used in s3 bucket and dynamoDB table names |
| aws_region | no       | "eu-central-1"   | AWS Region where resources will be deployed                  |

if needed default variable values can be changed on the run of `terraform apply`
```
terraform apply -var="aws_region=..." -var="env_name=..."                                            
```

#### **Created resources**
Creates following resources in AWS:

```
aws_dynamodb_table.dynamodb-terraform-state-lock
aws_s3_bucket.terraform_state_s3_bucket
aws_s3_bucket_acl.terraform_state_s3_bucket_acl
aws_s3_bucket_public_access_block.terraform_state_s3_bucket_public_access_block
aws_s3_bucket_server_side_encryption_configuration.cassandra_backups_s3_bucket_encryption_config
```

### Module `main/`
Main Terraform module porvisions VPC with single public subnet, and single EC2 instance with k3s deployed on it. EC2 is publicly accissble. 

#### **How to apply**
1. make sure pre requisites are fullfilled
2. From [infra/main](https://github.com/antomer/nb-test-task/tree/master/task-3/infra/init/) folder run following command:
    ```
    terraform init 
    terraform apply
    ```

It will take few minutes to provision all resources.

#### **Outputs**
Main module have following outputs:

| output name     | description                    | sensitive |
|-----------------|--------------------------------|-----------|
| ssh_private_key | SSH key to connect to k3s node | true      |
| public_ip       | Public IP of k3s node          | false     |
| kubeconfig      | Kubeconfig to connecto to k3s  | true      |


#### **Variables**

| var name          | required | default value    | description                                                  |
|-------------------|----------|------------------|--------------------------------------------------------------|
| env_name          | no       | "nb-development" | environemnt name, used in s3 bucket and dynamoDB table names |
| aws_region        | no       | "eu-central-1"   | AWS Region where resources will be deployed                  |
| vpc_cidr          | no       | "10.0.0.0/16"    | CIDR block for VPC                                           |
| public_subnet     | no       | "10.0.101.0/24"  | CIDR block for public subnet                                 |
| k3s_instance_type | no       | "t3.micro"       | AWS EC2 instance type for k3s                                |

if needed default variable values can be changed on the run of `terraform apply`
```
terraform apply -var="aws_region=..." -var="env_name=..." ...                                         
```

#### **Created resources**

Creates following resources in AWS:
```
aws_iam_instance_profile.k3s
aws_iam_policy.k3s
aws_iam_policy_attachment.k3s
aws_iam_role.k3s
aws_key_pair.ssh
aws_security_group.k3s
null_resource.wait_for_k3s
ssh_resource.kubeconfig
tls_private_key.ssh
module.node.data.aws_partition.current
module.node.data.aws_ssm_parameter.this[0]
module.node.aws_instance.this[0]
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_subnet.public[0]
module.vpc.aws_vpc.this[0]
```


---

## Part 3. CI/CD

CI/CD of app is implemented using GitHub Actions with single pipeline defined in [.github/workflows/ci-cd.yaml](https://github.com/antomer/nb-test-task/blob/main/.github/workflows/ci-cd.yaml)


Pipeline consists of 3 jobs:
1. `lint-test` - runs unit tests and lint checks for application code
2. `build` - builds and pushes container image to `DockerHub`
3. `deploy` - using Helm deploys container image built in step 2. to AWS 

### `lint-test` job
`lint-test` job runs unit tests and lint checks for application code.

### `build` job
`build` job builds and pushes container image to `DockerHub`, Requires repository secrets `DOCKER_HUB_USERNAME` `DOCKER_HUB_TOKEN` to be configured and match `DOCKER_HUB_REPOSITORY` set in `env` section. At the moment images are pushed to public DockerHub repositoryu `antomer/nb-simple-service`

`build` job is run only if `lint-test` job was successful

### `deploy` job
`deploy` job deploy helm chart with newly build image to K3S cluster. Helm chart and its values file is located in [app/.deploy/helm/](https://github.com/antomer/nb-test-task/tree/master/task-3/app/.deploy/helm/) folder 

### Triggers 

Pipeline is triggered automatically in two cases:
1. on each commit in Pull Request made to master (triggers only `lint-test` and `build` jobs)
2. on each commit made in `master` branch. (triggers `lint-test` `build` and `deploy` jobs)

Since it is a monorepo, GitHub Action is configured to execute only if changes made in `task-3/app/` folder or pipeline definition file itself.

