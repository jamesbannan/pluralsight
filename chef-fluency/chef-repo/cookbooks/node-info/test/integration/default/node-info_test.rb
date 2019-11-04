# InSpec test for recipe node-info::node-info

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

filename = 'node-info.txt'

describe file("/#{filename}") do
  it { should exist }
end

describe file("/#{filename}") do
  its('content') { should_not be nil }
end

describe file("/#{filename}") do
  its('content') { should match 'This is a test.' }
end
