#
# Cookbook Name:: bind9
# Recipe:: default
#
# Copyright 2013, Deutsche Telekom HBS Inc
#
# All rights reserved - Do Not Redistribute
#
bind_service = node["bind9"]["service_name"]


if node[:bind9][:keys][:rndc]
  template "#{node[:bind9][:dir]}/rndc.key" do
    owner node['bind9']['user']
    group node['bind9']['group']
    mode 0644
    notifies :restart, "service[#{bind_service}]"
  end
end

if node[:bind9][:acl]
  template "#{node[:bind9][:dir]}/named.conf.acl" do
    owner node['bind9']['user']
    group node['bind9']['group']
    mode 0644
    notifies :reload, "service[#{bind_service}]"
    end
end

template "#{node[:bind9][:dir]}/named.conf.local" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  variables(
    :zones => node['bind9']['id']
  )
  notifies :reload, "service[#{bind_service}]"
end

template "#{node[:bind9][:dir]}named.conf.options" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{bind_service}]"
end

template "#{node[:bind9][:dir]}named.conf.default-zones" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{bind_service}]"
end

  if node['bind9']['servers']
  template "#{node[:bind9][:dir]}/named.conf.servers" do
    cookbook "bind9"
    owner node['bind9']['user']
    group node['bind9']['group']
    mode 0600
    notifies :restart, "service[#{bind_service}]"
  end
end

template "#{node[:bind9][:dir]}/named.conf.log" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{bind_service}]"
end

template "#{node[:bind9][:dir]}/named.conf.channles" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{bind_service}]"
end

template "#{node[:bind9][:dir]}/named.conf.keys" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  notifies :reload, "service[#{bind_service}]"
end

template "#{node[:bind9][:dir]}/named.conf" do
  owner node['bind9']['user']
  group node['bind9']['group']
  mode 0644
  variables(
    :zones => node['bind9']['id'].keys.sort
  )
  notifies :reload, "service[#{bind_service}]"
end

include_recipe 'bind9::default_zone'
