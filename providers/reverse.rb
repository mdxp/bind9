IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/
MAX = 99

action :create do
  zones = Hash.new
  @new_resource.hosts.each do |ip,fqdn|
    next if !IP_CIDR_VALID_REGEX.match(ip)
    iparr = ip.split(".")
    zone_name = "#{iparr[2]}.#{iparr[1]}.#{iparr[0]}.in-addr.arpa"
    unless zones[zone_name] then zones[zone_name] = Hash.new end
    zones[zone_name][iparr[3]] = fqdn
    node.set_unless['bind9']['id'][new_resource.view][new_resource.type][zone_name] = 0
  end

  zones.each do |zone_name,ips|
    if new_resource.view != "noview"
       zone_file_name= "#{node['bind9']['zonedir']}/#{zone_name}.#{new_resource.view}"
   else
       zone_file_name= "#{node['bind9']['zonedir']}/#{zone_name}"
    end
    template zone_file_name do
      source "zone_reverse.erb"
      cookbook "bind9"
      owner node['bind9']['user']
      group node['bind9']['group']
      mode 0600
      variables(
        :ips => ips.sort,
        :new_resource => new_resource
      )
      #reload does not work properly
      notifies :restart, resources(:service => node["bind9"]["service_name"])
    end

    update_reverse = true
    #break the loop between template and number increment with a helper variable
    ruby_block "update-id_#{zone_name}.#{new_resource.view}" do
      block do
        if update_reverse
          if node['bind9']['id'][new_resource.view][new_resource.type][zone_name] < MAX
            node.set['bind9']['id'][new_resource.view][new_resource.type][zone_name] = node['bind9']['id'][new_resource.view][new_resource.type][zone_name] + 1
          else
            node.set['bind9']['id'][new_resource.view][new_resource.type][zone_name] = 1
          end
          update_reverse = false
        end
      end
      action :nothing
      subscribes :create, resources(:template => zone_file_name), :immediately
      notifies :create, resources(:template => zone_file_name)
    end

  end
end
