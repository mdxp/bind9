IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/
MAX = 99

action :create do
  zone_file_name = nil
    hosts = Hash.new
  if !node['bind9']['id'].has_key?(@new_resource.view)
    node.set['bind9']['id'][@new_resource.view] = Hash.new
  end
  if !node['bind9']['id'][new_resource.view].has_key?(@new_resource.type)
    node.set['bind9']['id'][@new_resource.view][@new_resource.type] = Hash.new
  end

#  node.set['bind9']['id'][new_resource.view][new_resource.type][@new_resource.domain] = Hash.new
   case new_resource.type
     when "master"
     @new_resource.hosts.each do |name,ip_name|
       hosts[name] = Hash.new
       hosts[name][:name] = name
       if IP_CIDR_VALID_REGEX.match(ip_name)
         hosts[name][:type] = "A"
         hosts[name][:ip_name] = ip_name
       else
         hosts[name][:type] = "CNAME"
         hosts[name][:ip_name] = "#{ip_name}."
       end
     end

     node.set_unless['bind9']['id'][new_resource.view][new_resource.type][@new_resource.domain] = 0
      if new_resource.view != "noview"
         zone_file_name= "#{node['bind9']['zonedir']}/#{new_resource.domain}.#{new_resource.view}"
     else
         zone_file_name= "#{node['bind9']['zonedir']}/#{new_resource.domain}"
      end
       template zone_file_name do
         source "zone.erb"
         cookbook "bind9"
         owner node['bind9']['user']
         group node['bind9']['group']
         mode 0600
         variables(
          :hosts => hosts.sort,
          :new_resource => new_resource
          )
          notifies :restart, resources(:service => node["bind9"]["service_name"])
        end

      update = true

      #break the loop between template and number increment with a helper variable
      ruby_block "update-id_#{new_resource.domain}.#{new_resource.view}" do
        block do
          if update
            if node['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] < MAX
              node.set['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] = node['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] + 1
            else
              node.set['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] = 1
            end
            update = false
          end
        end
        action :nothing
        subscribes :create, resources(:template => zone_file_name), :immediately
        notifies :create, resources(:template => zone_file_name)
      end

    when "forward"
      node.set['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] = @new_resource.ip
    when "slave"
      node.set['bind9']['id'][new_resource.view][new_resource.type][new_resource.domain] = @new_resource.ip
    end
end
