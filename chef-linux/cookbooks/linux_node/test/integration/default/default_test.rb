# InSpec test for recipe linux_node::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

unless os.windows?
  describe user('root') do
    it { should exist }
  end
end

describe port(80) do
  it { should_not be_listening }
end
