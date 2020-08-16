#
# Cookbook:: windows_node
# Recipe:: userinfo
#
# Copyright:: 2020, The Authors, All Rights Reserved.

users = data_bag('users')

users.each do |user|
  userobject = data_bag_item('users', user)

  file "C:/Windows/Temp/#{userobject['id']}.txt" do
    content "The user is #{userobject['fullName']}, they live in #{userobject['city']} which is in #{userobject['country']}."
  end
end
