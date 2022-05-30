variable "access_key" {
  # export TF_VAR_access_key=...
  # or
  # default = "access_key_value"
}

variable "secret_key" {
  # export TF_VAR_access_key=...
  # or
  # default = "secret_key_value"
}

variable "region" {
  default = "KR"
}

variable "zone" {
  default = "KR-2"
}

variable name_scn01 {
  default = "tf-scn01"
}

variable "login_key_name" {
  default = "tf-test-key"
}

variable "server_name" {
  default = "tf-test-vm"
}

variable "server_image_product_code" {
  default = "SW.VSVR.OS.LNX64.UBNTU.SVR1804.B050" #UBUNTU 18.04
}

variable "server_product_code" {
  default = "SVR.VSVR.HICPU.C002.M004.NET.HDD.B050.G002" #SPSVRSTAND000056
}

variable "port_forwarding_external_port" {
  default = "5088"
}
