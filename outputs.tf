output "security_group_ids" {
  description = "The IDs of the created security groups."
  value = {
    ssh_sg_id          = aws_security_group.ssh.id
    public_http_sg_id  = aws_security_group.public_http.id
    private_http_sg_id = aws_security_group.private_http.id
  }
}
