name 'motd_linux'

default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'motd_linux::default'
run_list 'motd::default'

# Specify a custom source for a single cookbook:
cookbook 'motd_linux', path: '..'
cookbook 'motd', '~> 1.0.1', :supermarket
