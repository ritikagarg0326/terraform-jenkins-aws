output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_instance_id" {
  value = module.jenkins.instance_id
}

output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "jenkins_url" {
  value = module.load_balancer.jenkins_url
}

output "load_balancer_dns" {
  value = module.load_balancer.dns_name
}
