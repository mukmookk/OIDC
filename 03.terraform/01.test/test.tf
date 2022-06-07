terraform {
	required_providers {
		libvirt = {
			source = "multani/libvirt"
			version = "0.6.3-1+4"
		}
	}
}

provider "libvirt" {
	alias = "hypervisor"
	uri = "qemu+ssh://hypervisor/system"
}

resource "libvirt_volume" "centos7-qcow2" {
	name = "centos7.qcow2"
	pool = "default"
	source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
	format = "qcow2"
}

resource "libvirt_domain" "centos7" {
	name = "centos7"
	memory = "1024"
	vcpu = 1

	network_interface {
		bridge = "br0"
	}

	disk {
		volume_id = "${libvirt_volume.centos7-qcow2.id}"
	}

	console {
		type = "pty"
		target_type = "serial"
		target_port = "0"
	}

	graphics {
		type = "spice"
		listen_type = "address"
		autoport = true
	}
}

output "ip" {
	value = "${libvirt_domain.centos7.network_interface.0.addresses}"
}