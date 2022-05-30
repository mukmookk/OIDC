provider "ncloud" {
  support_vpc = true
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = var.region
}

resource "random_id" "id" {
  byte_length = 4
}

resource "ncloud_login_key" "key" {
  key_name = "${var.login_key_name}${random_id.id.hex}"
}

resource "ncloud_vpc" "vpc" {
  name            = "vpc2"
  ipv4_cidr_block = "10.0.0.0/16"
}

resource "ncloud_subnet" "bastion_subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 1)
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "bastion-subnet"
  usage_type     = "GEN"
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.bastion_subnet.id
  name                      = "${var.server_name}${random_id.id.hex}"
  server_image_product_code = var.server_image_product_code
  server_product_code       = var.server_product_code
  login_key_name            = ncloud_login_key.key.key_name
  zone                      = var.zone
}

data "ncloud_root_password" "rootpwd" {
  server_instance_no = ncloud_server.server.id
  private_key        = ncloud_login_key.key.private_key
}

resource "ncloud_public_ip" "public_ip_scn_01" {
  server_instance_no = ncloud_server.server.id
  description        = "for ${var.name_scn01}"
}

locals {
  scn01_inbound = [
    [1, "TCP", "119.195.157.116/32", "80", "ALLOW"],
    #[2, "TCP", "0.0.0.0/0", "443", "ALLOW"],
    #[3, "TCP", "${var.client_ip}/32", "22", "ALLOW"],
    #[4, "TCP", "${var.client_ip}/32", "3389", "ALLOW"],
    [2, "TCP", "0.0.0.0/0", "1-65535", "ALLOW"],
    #[5, "TCP", "0.0.0.0/0", "32768-65535", "ALLOW"],
    #[197, "TCP", "0.0.0.0/0", "1-65535", "DROP"],
    [3, "UDP", "0.0.0.0/0", "1-65535", "ALLOW"],
    [4, "ICMP", "0.0.0.0/0", "1-65535", "ALLOW"],
  ]

  scn01_outbound = [
    #[1, "TCP", "0.0.0.0/0", "80", "ALLOW"],
    #[2, "TCP", "0.0.0.0/0", "443", "ALLOW"],
    #[3, "TCP", "${var.client_ip}/32", "1000-65535", "ALLOW"],
    [1, "TCP", "0.0.0.0/0", "1-65535", "ALLOW"],
    #[197, "TCP", "0.0.0.0/0", "1-65535", "DROP"],
    [198, "UDP", "0.0.0.0/0", "1-65535", "ALLOW"],
    [199, "ICMP", "0.0.0.0/0", "1-65535", "ALLOW"]
  ]
}

resource "ncloud_network_acl_rule" "network_acl_01_rule" {
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  dynamic "inbound" {
    for_each = local.scn01_inbound
    content {
      priority    = inbound.value[0]
      protocol    = inbound.value[1]
      ip_block    = inbound.value[2]
      port_range  = inbound.value[3]
      rule_action = inbound.value[4]
      description = "for ${var.name_scn01}"
    }
  }

  dynamic "outbound" {
    for_each = local.scn01_outbound
    content {
      priority    = outbound.value[0]
      protocol    = outbound.value[1]
      ip_block    = outbound.value[2]
      port_range  = outbound.value[3]
      rule_action = outbound.value[4]
      description = "for ${var.name_scn01}"
    }
  }
}

#data "ncloud_port_forwarding_rules" "rules" {
#  zone = ncloud_server.server.zone
#}

#resource "ncloud_port_forwarding_rule" "forwarding" {
#  port_forwarding_configuration_no = data.ncloud_port_forwarding_rules.rules.id
#  server_instance_no               = ncloud_server.server.id
#  port_forwarding_external_port    = var.port_forwarding_external_port
#  port_forwarding_internal_port    = "22"
#}

resource "null_resource" "ssh" {
  provisioner "local-exec" {
    command = <<EOF
      echo "[demo]" > inventory
      echo "${ncloud_server.server.name} ansible_host='${ncloud_public_ip.public_ip_scn_01.public_ip}' ansible_port='22' ansible_ssh_user=root ansible_ssh_pass='${data.ncloud_root_password.rootpwd.root_password}'" >> inventory
      echo "[all:vars]" >> inventory
      echo "ansible_python_interpreter=/usr/bin/python3" >> inventory
EOF

  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i inventory playbook.yml
    
EOF

  }
}
