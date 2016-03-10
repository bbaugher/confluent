require 'spec_helper'

describe 'confluent::schema-registry' do

  before do
    Fauxhai.mock(platform:'centos', version:'6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["schema-registry"]["schema-registry.properties"]["key"] = "value1"
      node.set["confluent"]["schema-registry"]["log4j.properties"]["key"] = "log1"
    end
  end

  let(:schema_template) { chef_run.template('/etc/schema-registry/schema-registry.properties') }
  let(:log4j_template) { chef_run.template('/etc/schema-registry/log4j.properties') }

  it 'should restart kafka-rest on config change' do
    chef_run.converge(described_recipe)
    expect(schema_template).to notify('service[schema-registry]').to(:restart)
    expect(log4j_template).to notify('service[schema-registry]').to(:restart)
  end

  it 'should configure schema-registry' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/schema-registry/schema-registry.properties').with_content('key=value1')
    expect(chef_run).to render_file('/etc/schema-registry/log4j.properties').with_content('key=log1')
  end

end
