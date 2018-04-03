#!/bin/bash
yum update -y
amazon-linux-extras install lamp-mariadb10.2-php7.2
yum install -y httpd
systemctl start httpd && systemctl enable httpd