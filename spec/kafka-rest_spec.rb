require 'spec_helper'

describe 'confluent::kafka-rest' do

  before do
    Fauxhai.mock(platform:'centos', version:'6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["kafka-rest"]["server.properties"]["key"] = "value1"
      node.set["confluent"]["kafka-rest"]["log4j.properties"]["key"] = "log1"
      node.set['confluent']['kafka']['server.properties']['broker.id'] = 1
      node.set['confluent']['kafka']['zookeepers'] = 'testhost.chefspec'
    end
  end

  let(:kafka_rest_template) { chef_run.template('/etc/kafka-rest/kafka-rest.properties') }
  let(:log4j_template) { chef_run.template('/etc/kafka-rest/log4j.properties') }

  it 'should restart kafka-rest on config change' do
    chef_run.converge(described_recipe)
    expect(kafka_rest_template).to notify('service[kafka-rest]').to(:restart)
    expect(log4j_template).to notify('service[kafka-rest]').to(:restart)
  end

end
