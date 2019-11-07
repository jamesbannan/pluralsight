#
# Cookbook:: node-packages
# Recipe:: packages
#
# Copyright:: 2019, The Authors, All Rights Reserved.

packages = [
    'ack',
    'silversearcher-ag',
    'htop',
    'jq',
    'pydf',
    'unzip'
]

if platform_family?("debian")
  packages.each do |name|
    package name do
      action :upgrade
    end
  end
end
