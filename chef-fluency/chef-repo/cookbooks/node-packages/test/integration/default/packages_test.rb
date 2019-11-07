# InSpec test for recipe node-packages::packages

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

packages = [
    'ack',
    'silversearcher-ag',
    'htop',
    'jq',
    'pydf',
    'unzip'
]

if os.debian?
  packages.each do |name|
    describe package(name) do
      it { should be_installed }
    end
  end
end
