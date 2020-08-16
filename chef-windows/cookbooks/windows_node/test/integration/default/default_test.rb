# InSpec test for recipe windows_node::default

unless os.linux?
  describe user('Administrator') do
    it { should exist }
  end
end

describe port(80) do
  it { should_not be_listening }
end
