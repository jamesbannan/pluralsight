# libraries/node_info.rb
module Node
  module SystemInfo
    def node_info
      # Declare variables
      hostname = node['hostname']
      fqdn = node['fqdn']
      platform = node['platform']
      platform_version = node['platform_version']
      cpu_cores = node['cpu']['cores']
      cpu_type = node['cpu']['0']['model_name']
      memory_total = node['memory']['total']
      memory_free = node['memory']['free']
      ipaddress = node['ipaddress']

      "\n
      Hostname: #{hostname}
      FQDN: #{fqdn}\n
      Operating System: #{platform.capitalize()} #{platform_version}
      CPU: #{cpu_cores} x #{cpu_type}
      Memory: #{memory_total} (#{memory_free} available)\n
      IP Address: #{ipaddress}\n"
    end
  end
end

Chef::Recipe.include(Node::SystemInfo)
Chef::Resource.include(Node::SystemInfo)