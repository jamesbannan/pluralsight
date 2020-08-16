name 'windows_node'

default_source :supermarket

run_list 'windows_node::default'

cookbook 'windows_node', path: '.'
