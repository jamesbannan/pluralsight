#
# Cookbook:: windows_packages
# Recipe:: packages
#
# Copyright:: 2020, The Authors, All Rights Reserved.

chocolatey_package "#{node['appname']}" do
  action :upgrade
end
