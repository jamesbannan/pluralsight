# Ensure IIS Service is running
describe service('W3SVC') do
  it { should be_installed }
  it { should be_running }
end

# Verify the 'Default Web Site'
describe iis_site('Default Web Site') do
  it { should exist }
  it { should be_running }
  it { should have_app_pool('DefaultAppPool') }
  its('app_pool') { should eq 'DefaultAppPool' }
  it { should have_binding('http *:80:') }
  its('bindings') { should include 'http *:80:' }
  it { should have_path('%SystemDrive%\\inetpub\\wwwroot') }
  its('path') { should eq '%SystemDrive%\\inetpub\\wwwroot' }
end

# Ensure the WebServer is running on port 80
describe port(80) do
  it { should be_listening }
end
