## Providers AWS
provider "aws" {
  assume_role {
    role_arn = var.switch_role_arn
  }

  region = var.region
}

## Data
data "aws_lb" "this" {
  name = var.lb_name
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.this.arn
  port              = 443
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}

## ACM
resource "aws_acm_certificate" "acm" {
  domain_name       = var.record_name
  validation_method = "DNS"
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "acm" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

## Add ACM on LB
resource "aws_lb_listener_certificate" "acm" {
  listener_arn    = data.aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.acm.arn
}

## ECR
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

## ECS Fargate
module "ecs_fargate" {
  source  = "brunordias/ecs-fargate/aws"
  version = "3.1.0"

  name                           = var.name
  region                         = var.region
  ecs_cluster                    = data.aws_ecs_cluster.cluster.arn
  image_uri                      = var.image_uri
  platform_version               = var.platform_version
  vpc_name                       = var.vpc_name
  subnet_name                    = var.subnet_name
  assign_public_ip               = var.assign_public_ip
  fargate_cpu                    = var.fargate_cpu
  fargate_memory                 = var.fargate_memory
  ecs_service_desired_count      = var.ecs_service_desired_count
  app_port                       = var.app_port
  load_balancer                  = var.load_balancer
  ecs_service                    = var.ecs_service
  service_discovery_namespace_id = var.service_discovery_namespace_id
  policies                       = var.policies
  lb_listener_arn                = [data.aws_lb_listener.https.arn]
  lb_path_pattern                = var.lb_path_pattern
  lb_host_header                 = var.lb_host_header
  lb_priority                    = var.lb_priority
  health_check                   = var.health_check
  capacity_provider_strategy     = var.capacity_provider_strategy
  autoscaling                    = var.autoscaling
  autoscaling_settings           = var.autoscaling_settings
  app_environment                = var.app_environment
  efs_volume_configuration       = var.efs_volume_configuration
  efs_mount_configuration        = var.efs_mount_configuration
  cloudwatch_settings            = var.cloudwatch_settings

  tags = var.tags
}

## Route 53
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = data.aws_lb.this.dns_name
    zone_id                = data.aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
