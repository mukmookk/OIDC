output "server_name_list" {
  value = join(",", ncloud_server.server.*.name)
}

output "server_passwd" {
  value = data.ncloud_root_password.rootpwd.root_password
  sensitive = true
}
