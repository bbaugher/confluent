require 'spec_helper'

describe 'confluent::default' do
  before do
    Fauxhai.mock(platform:'centos', version:'6.5')
  end

  context 'with defaults' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new
    end

    it 'should install confluent' do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory('/opt/confluent')
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/confluent-2.0.1-2.11.7.zip").with(source: 'http://packages.confluent.io/archive/2.0/confluent-2.0.1-2.11.7.zip')
      expect(chef_run).to run_execute("unzip -q #{Chef::Config[:file_cache_path]}/confluent-2.0.1-2.11.7.zip -d /opt/confluent")
    end

  end

  context 'with overrides' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["confluent"]["version"] = "1.2.1"
        node.set["confluent"]["scala_version"] = "2.11.1"
        node.set["confluent"]["install_dir"] = "/opt/confluent_other"
      end
    end

    it 'should configure kafka' do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory('/opt/confluent_other')
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/confluent-1.2.1-2.11.1.zip").with(source: 'http://packages.confluent.io/archive/1.2/confluent-1.2.1-2.11.1.zip')
      expect(chef_run).to run_execute("unzip -q #{Chef::Config[:file_cache_path]}/confluent-1.2.1-2.11.1.zip -d /opt/confluent_other")
    end
  end
end
