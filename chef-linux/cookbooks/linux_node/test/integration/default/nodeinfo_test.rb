# InSpec test for recipe linux_node::nodeinfo

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

filename = 'node-info.txt'
folder = '/tmp/'

describe file("#{folder}#{filename}") do
  it { should exist }
  its('type') { should cmp 'file' }
  it { should be_file }
  it { should_not be_directory }
  its('content') { should_not be nil }
  its('mode') { should cmp '00755' }
end
