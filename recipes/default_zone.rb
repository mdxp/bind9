#
# Cookbook Name:: bind9
# Recipe:: deaful-zone
#
#
#
#
template "#{node[:bind9][:dir]}/named.conf.default-zones" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{node["bind9"]["service_name"]}]"
end

['/db.0','/db.127','/db.255','/db.local','/db.root'].each do |filen|
 cookbook_file node[:bind9][:zonedir] + filen do
    owner node['bind9']['user']
    group node['bind9']['group']
    action :create
  end
end
