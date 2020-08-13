filename = 'node-info.txt'
folderpath = 'C:/Windows/Temp'

describe file("#{folderpath}/#{filename}") do
  it { should exist }
  its('type') { should cmp 'file' }
  it { should be_file }
  it { should_not be_directory }
end