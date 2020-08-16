name 'userinfo'

default_source :supermarket

run_list 'windows_node::userinfo'

cookbook 'windows_node', path: '..'
