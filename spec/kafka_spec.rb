require 'spec_helper'

describe 'confluent::kafka' do

  before do
    Fauxhai.mock(platform:'centos', version:'6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["kafka"]["server.properties"]["key"] = "value1"
      node.set["confluent"]["kafka"]["log4j.properties"]["key"] = "log1"
      node.set['confluent']['kafka']['server.properties']['broker.id'] = 1
      node.set['confluent']['kafka']['zookeepers'] = 'testhost.chefspec'
    end
  end

  let(:kafka_template) { chef_run.template('/etc/kafka/server.properties') }
  let(:log4j_template) { chef_run.template('/etc/kafka/log4j.properties') }

  it 'should restart kafka on config change' do
    chef_run.converge(described_recipe)
    expect(kafka_template).to notify('service[kafka]').to(:restart)
    expect(log4j_template).to notify('service[kafka]').to(:restart)
  end

end
