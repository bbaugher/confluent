require 'spec_helper'

describe 'confluent::kafka-connect' do

  before do
    Fauxhai.mock(platform: 'centos', version: '6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["kafka-connect"]["kafka-connect.properties"]["key"] = "value1"
      node.set["confluent"]["kafka-connect"]["log4j.properties"]["key"] = "log1"
    end
  end

  let(:kafka_rest_template) { chef_run.template('/etc/kafka-connect/kafka-connect.properties') }
  let(:log4j_template) { chef_run.template('/etc/kafka-connect/log4j.properties') }

  it 'should restart kafka-connect on config change' do
    chef_run.converge(described_recipe)
    expect(kafka_rest_template).to notify('service[kafka-connect]').to(:restart)
    expect(log4j_template).to notify('service[kafka-connect]').to(:restart)
  end

  it 'should configure kafka-connect' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/kafka-connect/kafka-connect.properties').with_content('key=value1')
    expect(chef_run).to render_file('/etc/kafka-connect/log4j.properties').with_content('key=log1')
  end

end
