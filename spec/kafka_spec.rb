# frozen_string_literal: true

require 'spec_helper'

describe 'confluent::kafka' do
  before do
    Fauxhai.mock(platform: 'centos', version: '6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['confluent']['kafka']['server.properties']['key'] = 'value1'
      node.override['confluent']['kafka']['log4j.properties']['key'] = 'log1'
      node.override['confluent']['kafka']['server.properties']['broker.id'] = 1
      node.override['confluent']['kafka']['zookeepers'] = 'testhost.chefspec'
    end
  end

  let(:kafka_template) { chef_run.template('/etc/kafka/server.properties') }
  let(:log4j_template) { chef_run.template('/etc/kafka/log4j.properties') }

  it 'should restart kafka on config change' do
    chef_run.converge(described_recipe)
    expect(kafka_template).to notify('service[kafka]').to(:restart)
    expect(log4j_template).to notify('service[kafka]').to(:restart)
  end

  it 'should configure kafka' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/kafka/server.properties').with_content('broker.id=1')
    expect(chef_run).to render_file('/etc/kafka/server.properties').with_content('zookeeper.connect=testhost.chefspec')
    expect(chef_run).to render_file('/etc/kafka/server.properties').with_content('key=value1')
    expect(chef_run).to render_file('/etc/kafka/log4j.properties').with_content('key=log1')
  end

  context 'with kerberos enabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['confluent']['kerberos']['enable'] = true
        node.override['confluent']['kerberos']['keytab'] = '/path/to/keytab'
        node.override['confluent']['kerberos']['realm'] = 'myrealm.net'
        node.override['confluent']['kafka']['server.properties']['broker.id'] = 1
        node.override['confluent']['kafka']['zookeepers'] = 'testhost.chefspec'
      end
    end

    it 'should configure java security' do
      chef_run.converge(described_recipe)
      # rubocop:disable LineLength
      expect(chef_run.node['confluent']['kafka']['env_vars']['KAFKA_OPTS']).to eq("-Djava.security.auth.login.config=#{chef_run.node['confluent']['install_dir']}/confluent-#{chef_run.node['confluent']['version']}/jaas.conf")
      # rubocop:enable LineLength
    end
  end
end
