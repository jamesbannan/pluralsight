#
# Cookbook:: node_site
# Recipe:: site
#
# Copyright:: 2019, The Authors, All Rights Reserved.

node_site_website 'httpd' do
    homepage "<h1>This site is running on #{node['hostname']} and the operating system is #{node['platform'].capitalize()}.</h1>"
end