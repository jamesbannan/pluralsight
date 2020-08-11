name 'windows_node'

default_source :supermarket

run_list 'windows_node::nodeinfo'

cookbook 'windows_node', path: '..'
cookbook 'windows_packages', path: '../../windows_packages'