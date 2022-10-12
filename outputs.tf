output "cluster_arn" {
  value       = data.aws_ecs_cluster.cluster.arn
  sensitive   = false
  description = "The ECS Cluster ARN"
  depends_on  = []
}

output "ecr_repo_uri" {
  value       = aws_ecr_repository.this.repository_url
  sensitive   = false
  description = "The URI of the ECR"
  depends_on  = []
}

output "ecs_service_name" {
  value       = "${var.name}-service"
  sensitive   = false
  description = "The ECS service name"
  depends_on  = []
}

output "route53_fqdn" {
  value       = aws_route53_record.record.fqdn
  sensitive   = false
  description = "The DNS record name"
  depends_on  = []
}
