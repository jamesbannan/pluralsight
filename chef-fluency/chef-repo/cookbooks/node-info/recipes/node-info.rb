#
# Cookbook:: node-info
# Recipe:: node-info
#
# Copyright:: 2019, The Authors, All Rights Reserved.

filename = 'node-info.txt'

file "/#{filename}" do
  content 'This is a test.'
end
