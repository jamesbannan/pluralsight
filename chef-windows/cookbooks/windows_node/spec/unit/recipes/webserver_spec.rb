#
# Cookbook:: windows_node
# Spec:: webserver
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'windows_node::webserver' do
  context 'When all attributes are default, on Windows Server 2019' do
    platform 'windows', '2019'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on Windows Server 2016' do
    platform 'windows', '2016'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
