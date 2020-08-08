if os.redhat?
  describe package 'httpd' do
    it { should be_installed }
  end
end

if os.redhat?
  describe service 'httpd' do
    it { should be_enabled }
    it { should be_running }
  end
end

if os.debian?
  describe package 'apache2' do
    it { should be_installed }
  end
end

if os.debian?
  describe service 'apache2' do
    it { should be_enabled }
    it { should be_running }
  end
end

describe port(80) do
  it { should be_listening }
  its('protocols') { should cmp 'tcp' }
end