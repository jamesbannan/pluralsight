#
# Cookbook:: node-info
# Recipe:: repositories
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_repository 'powershell' do
  uri "https://packages.microsoft.com/ubuntu/#{node['lsb']['release']}/prod"
  components ['main']
  arch 'amd64'
  key 'https://packages.microsoft.com/keys/microsoft.asc'
  action :add
end

package 'apt-transport-https' do
  action :upgrade
end