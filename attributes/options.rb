if platform_family?("debian")
  default[:bind9][:options]["directory"] = '"/var/cache/bind"'
elsif platform_family?("rhel")
  default[:bind9][:options]["directory"] = '"/var/named"'
end
default[:bind9][:options]["dnssec-validation"] = "auto"
default[:bind9][:options]["auth-nxdomain"] = "no"
default[:bind9][:options]["allow-recursion"] = ['none']
# Allow query is any by default , It's here so you can
default[:bind9][:options]["allow-query"] = ['any']
default[:bind9][:options]["listen-on-v6"] = ['none']
default[:bind9][:options]["listen-on"] = ['any']
