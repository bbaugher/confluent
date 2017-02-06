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
        node.override["confluent"]["version"] = "1.2.1"
        node.override["confluent"]["scala_version"] = "2.11.1"
        node.override["confluent"]["install_dir"] = "/opt/confluent_other"
      end
    end

    it 'should configure kafka' do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory('/opt/confluent_other')
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/confluent-1.2.1-2.11.1.zip").with(source: 'http://packages.confluent.io/archive/1.2/confluent-1.2.1-2.11.1.zip')
      expect(chef_run).to run_execute("unzip -q #{Chef::Config[:file_cache_path]}/confluent-1.2.1-2.11.1.zip -d /opt/confluent_other")
    end
  end

  context 'with kerberos enabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override["confluent"]["kerberos"]["enable"] = true
        node.override["confluent"]["kerberos"]["keytab"] = '/path/to/keytab'
        node.override["confluent"]["kerberos"]["realm"] = 'myrealm.net'
      end
    end

    it 'should config JAAS' do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_template('/opt/confluent/confluent-2.0.1/jaas.conf')
      expect(chef_run).to render_file('/opt/confluent/confluent-2.0.1/jaas.conf').with_content { |content|
        expect(content).to include('KafkaServer {')
        expect(content).to include('com.sun.security.auth.module.Krb5LoginModule required')
        expect(content).to include('useKeyTab=true')
        expect(content).to include('storeKey=true')
        expect(content).to include('keyTab="/path/to/keytab"')
        expect(content).to include('principal="confluent/fauxhai.local@myrealm.net"')
        expect(content).to include('KafkaClient {')
      }
    end

    context 'and realm not specified' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.override["confluent"]["kerberos"]["enable"] = true
          node.override["confluent"]["kerberos"]["keytab"] = '/path/to/keytab'
        end
      end

      it 'should raise exception' do
        expect { chef_run.converge(described_recipe) }.to raise_error(RuntimeError)
      end
    end

    context 'and keytab_location not specified' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.override["confluent"]["kerberos"]["enable"] = true
          node.override["confluent"]["kerberos"]["realm"] = 'myrealm.net'
        end
      end

      it 'should raise exception' do
        expect { chef_run.converge(described_recipe) }.to raise_error(RuntimeError)
      end
    end
  end
end
