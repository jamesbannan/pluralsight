#
# Cookbook:: windows_node
# Spec:: nodeinfo
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

foldername = 'C:/Windows/Temp'
filename = 'node-info.txt'
notfilename = 'not-node-info.txt'

describe 'windows_node::nodeinfo' do
  context 'When all attributes are default, on Windows 2019' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2019').converge(described_recipe) }

    it 'creates a template with the default action' do
      expect(chef_run).to create_template("#{foldername}/#{filename}")
      expect(chef_run).to_not create_template("#{foldername}/#{notfilename}")
    end
  end

  context 'When all attributes are default, on Windows 2016' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2016').converge(described_recipe) }

    it 'creates a template with the default action' do
      expect(chef_run).to create_template("#{foldername}/#{filename}")
      expect(chef_run).to_not create_template("#{foldername}/#{notfilename}")
    end
  end
end
