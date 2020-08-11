#
# Cookbook:: windows_node
# Recipe:: nodeinfo
#
# Copyright:: 2020, The Authors, All Rights Reserved.

folderpath = 'C:/Windows/Temp'

template "#{folderpath}/node-info.txt" do
  source 'node-info.txt.erb'
end
