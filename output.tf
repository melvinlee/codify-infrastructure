output "public_ip" {
  value = "${aws_instance.ansible-controlplane.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.ansible-controlplane.public_dns}"
}
