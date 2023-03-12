output "ssh_private_key" {
  description = "SSH private key generated for the instance microk8s"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "public_ip" {
  description = "Public IP name of the instance"
  value       = module.node.public_ip
}

output "kubeconfig" {
  value       = ssh_resource.kubeconfig.result
  description = "kubeconfig to acces k3s cluster"
  sensitive   = true
}
