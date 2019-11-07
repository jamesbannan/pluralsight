#
# Cookbook:: node-info
# Recipe:: node-info
#
# Copyright:: 2019, The Authors, All Rights Reserved.

folder = '/'
filename = 'node-info.txt'
content = 'This is a test.'

file "#{folder}#{filename}" do
  content "#{content}"
end

#if platform_family?("debian")
#  file "#{folder}#{filename}" do
#    content "#{content}"
#  end
#end
