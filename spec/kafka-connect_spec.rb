# frozen_string_literal: true

require 'spec_helper'

describe 'confluent::kafka-connect' do
  before do
    Fauxhai.mock(platform: 'centos', version: '6.7')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['confluent']['kafka-connect']['worker.properties']['key'] = 'value1'
      node.override['confluent']['kafka-connect']['log4j.properties']['log4j.test.property'] = 'test'
      node.override['confluent']['kafka-connect']['jar_urls'] = ['http://search.maven.org/remotecontent?filepath=org/apache/jclouds/chef/chef-project/1.8.1/chef-project-1.8.1-tests.jar']
      node.override['confluent']['kafka-connect']['properties_files'] = { 'test_file.properties' => { 'test.property' => 'test' } }
    end
  end

  let(:extracted_directory) { '/opt/confluent/confluent-2.0.1' }
  let(:kafka_confluent_properties_template) { chef_run.template("#{extracted_directory}/etc/kafka-connect/kafka-connect.properties") }
  let(:log4j_template) { chef_run.template("#{extracted_directory}/etc/kafka/connect-log4j.properties") }

  it 'should create a link to the kafka-connect directory' do
    expect(chef_run.converge(described_recipe)).to create_directory("#{extracted_directory}/etc/kafka-connect")
    expect(chef_run.converge(described_recipe)).to create_link('/etc/kafka-connect')
  end

  it 'should create a directory to save jars to' do
    expect(chef_run.converge(described_recipe)).to create_directory("#{extracted_directory}/share/java/kafka-connect-all")
  end

  it 'should pull down jars to use' do
    expect(chef_run.converge(described_recipe)).to create_remote_file_if_missing("#{extracted_directory}/share/java/kafka-connect-all/chef-project-1.8.1-tests.jar").with(backup: false)
  end

  it 'should configure worker properties file' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/kafka-connect/worker.properties').with_content('key=value1')
    expect(chef_run).to render_file("#{extracted_directory}/etc/kafka/connect-log4j.properties").with_content(/log4j.test.property=test/)
  end

  it 'should create service files' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file("#{extracted_directory}/bin/kafka-connect-start")
    expect(chef_run).to render_file("#{extracted_directory}/bin/kafka-connect-stop")
    expect(chef_run).to render_file('/etc/init.d/kafka-connect')
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
      expect(chef_run.node['confluent']['kafka-connect']['env_vars']['KAFKA_OPTS']).to eq("-Djava.security.auth.login.config=#{chef_run.node['confluent']['install_dir']}/confluent-#{chef_run.node['confluent']['version']}/jaas.conf")
      # rubocop:enable LineLength
    end
  end
end
