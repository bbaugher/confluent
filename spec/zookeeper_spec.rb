# frozen_string_literal: true

require 'spec_helper'

describe 'confluent::zookeeper' do
  before do
    Fauxhai.mock(platform: 'centos', version: '6.7')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['confluent']['zookeeper']['test.properties'] = 'test.property'
    end
  end

  let(:extracted_directory) { '/opt/confluent/confluent-2.0.1' }

  it 'should create a link to kafka directory where confluent files are stored' do
    expect(chef_run.converge(described_recipe)).to create_link('/etc/kafka')
  end

  it 'should create service files' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file("#{extracted_directory}/bin/zookeeper-server-stop")
    expect(chef_run).to render_file('/etc/init.d/zookeeper')
  end
end
