# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'motd_linux'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'motd_linux::default'

# Specify a custom source for a single cookbook:
cookbook 'motd_linux', path: '.'
cookbook 'motd', '~> 1.0.1', :supermarket
cookbook 'motd_chef_status', '~> 1.0.3', :supermarket
