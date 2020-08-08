#
# Cookbook:: linux_node
# Spec:: nodeinfo
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'linux_node::nodeinfo' do

  context 'When all attributes are default, on Ubuntu 20.04' do

    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe) }

    it 'creates a template with the default action' do
      expect(chef_run).to create_template('/tmp/node-info.txt')
      expect(chef_run).to_not create_template('/tmp/not-node-info.txt')
    end
  
  end

  context 'When all attributes are default, on CentOS 8' do

    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge(described_recipe) }

    it 'creates a template with the default action' do
      expect(chef_run).to create_template('/tmp/node-info.txt')
      expect(chef_run).to_not create_template('/tmp/not-node-info.txt')
    end

  end

end
