name 'linux_node'

default_source :supermarket

run_list 'linux_node::default'
run_list 'linux_node::userinfo'

cookbook 'linux_node', path: '..'