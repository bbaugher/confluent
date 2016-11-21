require 'spec_helper'

describe 'confluent::kafka-connect' do

  before do
    Fauxhai.mock(platform: 'centos', version: '6.7')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["confluent"]["kafka-connect"]["worker.properties"]["key"] = "value1"
      node.set["confluent"]["kafka-connect"]["log4j.properties"]["log4j.test.property"] = "test"
      node.set["confluent"]["kafka-connect"]["jar_urls"] = ['https://raw.github.com/alex-bezek/raw_files/master/sqljdbc41.jar']
      node.set["confluent"]["kafka-connect"]["properties_files"] = { 'test_file.properties' => {'test.property' => 'test'}}
    end
  end

  let(:extracted_directory) { '/opt/confluent/confluent-2.0.1' }
  let(:kafka_confluent_properties_template) { chef_run.template("#{extracted_directory}/etc/kafka-connect/kafka-connect.properties") }
  let(:log4j_template) { chef_run.template("#{extracted_directory}/etc/kafka/connect-log4j.properties") }

  it 'should create a link' do
    expect(chef_run.converge(described_recipe)).to create_link('/etc/kafka-connect')
  end

  it 'should create a kafka-connect directory' do
    expect(chef_run.converge(described_recipe)).to create_directory('/opt/confluent/confluent-2.0.1/etc/kafka-connect')
  end

  it 'should pull down jars to use' do
    expect(chef_run.converge(described_recipe)).to create_remote_file_if_missing("#{extracted_directory}/share/java/kafka-connect-jdbc/sqljdbc41.jar").with(backup: false)
  end

  it 'should configure worker properties file' do
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/kafka-connect/worker.properties').with_content('key=value1')
    expect(chef_run).to render_file("#{extracted_directory}/etc/kafka/connect-log4j.properties").with_content(/log4j.test.property=test/)
  end
end
