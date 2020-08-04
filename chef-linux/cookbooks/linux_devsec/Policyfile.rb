# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

name 'linux_devsec'

default_source :supermarket

run_list 'linux_devsec::default'

cookbook 'linux_devsec', path: '.'
cookbook 'os-hardening', '= 4.0.0'
