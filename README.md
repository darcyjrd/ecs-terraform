# aws-app-ecs

Projeto para criação de APP genérico no ECS.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_environment | List of one or more environment variables to be inserted in the container. | `list(any)` | `[]` | no |
| app\_port | The application TCP port number. | `number` | `80` | no |
| assign\_public\_ip | Assign a public IP address to the ENI | `bool` | `false` | no |
| autoscaling | Boolean designating an Auto Scaling. | `bool` | `false` | no |
| autoscaling\_settings | Settings of Auto Scaling. | `map(any)` | <pre>{<br>  "max_capacity": 5,<br>  "min_capacity": 1,<br>  "scale_in_cooldown": 300,<br>  "scale_out_cooldown": 300,<br>  "target_cpu_value": 65<br>}</pre> | no |
| capacity\_provider\_strategy | The capacity provider strategy to use for the service. | `map(any)` | <pre>{<br>  "base": null,<br>  "capacity_provider": "FARGATE_SPOT",<br>  "weight": 100<br>}</pre> | no |
| cloudwatch\_log\_group\_name | The name of an existing CloudWatch group. | `string` | `""` | no |
| cluster\_name | The ECS cluster name used for this app. | `string` | n/a | yes |
| ecs\_service | Boolean designating a service. | `bool` | `true` | no |
| ecs\_service\_desired\_count | The number of instances of the task definition to place and keep running. | `number` | `1` | no |
| efs\_mount\_configuration | Settings of EFS mount configuration. | `list(any)` | `[]` | no |
| efs\_volume\_configuration | Settings of EFS volume configuration. | `list(any)` | `[]` | no |
| fargate\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units). | `number` | `256` | no |
| fargate\_essential | Boolean designating a Fargate essential container. | `bool` | `true` | no |
| fargate\_memory | Fargate instance memory to provision (in MiB). | `number` | `512` | no |
| health\_check | Health check in Load Balance target group. | `map(any)` | <pre>{<br>  "enabled": true,<br>  "healthy_threshold": 2,<br>  "interval": 30,<br>  "matcher": "200",<br>  "path": "/",<br>  "port": "traffic-port",<br>  "protocol": "HTTP",<br>  "timeout": 5,<br>  "unhealthy_threshold": 10<br>}</pre> | no |
| hosted\_zone | Route 53 hosted zone name for this app. | `string` | n/a | yes |
| image\_uri | The container image URI. | `string` | n/a | yes |
| lb\_host\_header | List of host header patterns to match. | `list(any)` | `null` | no |
| lb\_listener\_arn | List of ARN LB listeners | `list(any)` | <pre>[<br>  ""<br>]</pre> | no |
| lb\_name | Load Balancer name. | `string` | n/a | yes |
| lb\_path\_pattern | List of path patterns to match. | `list(any)` | `null` | no |
| lb\_priority | The priority for the rule between 1 and 50000. | `number` | `null` | no |
| lb\_target\_group\_port | The port on which targets receive traffic, unless overridden when registering a specific target. | `number` | `80` | no |
| lb\_target\_group\_protocol | The protocol to use for routing traffic to the targets. Should be one of TCP, TLS, UDP, TCP\_UDP, HTTP or HTTPS. | `string` | `"HTTP"` | no |
| lb\_target\_group\_type | The type of target that you must specify when registering targets with this target group. | `string` | `"ip"` | no |
| load\_balancer | Boolean designating a load balancer. | `bool` | `true` | no |
| log\_retention\_in\_days | The number of days to retain log in CloudWatch. | `number` | `7` | no |
| name | Used to name resources and prefixes. | `string` | n/a | yes |
| platform\_version | The Fargate platform version on which to run your service. | `string` | `"1.4.0"` | no |
| policies | List of one or more IAM policy ARN to be used in the Task execution IAM role. | `list(any)` | `[]` | no |
| record\_name | Route 53 record name for this app. | `string` | n/a | yes |
| region | The AWS Region. | `string` | n/a | yes |
| service\_discovery\_namespace\_id | Service Discovery Namespace ID. | `string` | `null` | no |
| subnet\_name | Lista dos nomes das subnets | `list(any)` | `[]` | no |
| switch\_role\_arn | Switch Role ARN do cliente. | `string` | n/a | yes |
| tags | A mapping of tags to assign to all resources. | `map(any)` | `{}` | no |
| vpc\_name | Nome da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_arn | The ECS Cluster ARN |
| ecr\_repo\_uri | The URI of the ECR |
| ecs\_service\_name | The ECS service name |
| route53\_fqdn | The DNS record name |