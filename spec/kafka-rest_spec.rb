# frozen_string_literal: true

require 'spec_helper'

describe 'confluent::kafka-rest' do
  before do
    Fauxhai.mock(platform: 'centos', version: '6.5')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['confluent']['kafka-rest']['kafka-rest.properties']['key'] = 'value1'
      node.override['confluent']['kafka-rest']['log4j.properties']['key'] = 'log1'
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

  context 'with kerberos enabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['confluent']['kerberos']['enable'] = true
        node.override['confluent']['kerberos']['keytab'] = '/path/to/keytab'
        node.override['confluent']['kerberos']['realm'] = 'myrealm.net'
      end
    end

    it 'should configure java security' do
      chef_run.converge(described_recipe)
      # rubocop:disable LineLength
      expect(chef_run.node['confluent']['kafka-rest']['env_vars']['KAFKAREST_OPTS']).to eq("-Djava.security.auth.login.config=#{chef_run.node['confluent']['install_dir']}/confluent-#{chef_run.node['confluent']['version']}/jaas.conf")
      # rubocop:enable LineLength
    end
  end
end
