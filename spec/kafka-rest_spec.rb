require 'spec_helper'

describe 'confluent::kafka-rest' do

  before do
    Fauxhai.mock(platform:'centos', version:'6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["kafka-rest"]["kafka-rest.properties"]["key"] = "value1"
      node.set["confluent"]["kafka-rest"]["log4j.properties"]["key"] = "log1"
    end
  end

  let(:kafka_rest_template) { chef_run.template('/etc/kafka-rest/kafka-rest.properties') }
  let(:log4j_template) { chef_run.template('/etc/kafka-rest/log4j.properties') }

  it 'should restart kafka-rest on config change' do
    chef_run.converge(described_recipe)
    expect(kafka_rest_template).to notify('service[kafka-rest]').to(:restart)
    expect(log4j_template).to notify('service[kafka-rest]').to(:restart)
  end

  it 'should configure kafka-rest' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/kafka-rest/kafka-rest.properties').with_content('key=value1')
    expect(chef_run).to render_file('/etc/kafka-rest/log4j.properties').with_content('key=log1')
  end

end
