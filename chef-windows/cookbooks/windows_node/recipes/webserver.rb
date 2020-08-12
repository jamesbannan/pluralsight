windows_node_webserver 'iis' do
  homepage "<h1>This site is running on #{node['hostname']} and the operating system is #{node['platform'].capitalize()}.</h1>"
end
