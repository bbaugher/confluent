# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'confluent-berkshelf'
  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest
  config.vm.box = 'bento/ubuntu-14.04'

  # zookeeper port
  config.vm.network 'forwarded_port', guest: 2181, host: 2181
  # Kafka Connector rest api port
  config.vm.network 'forwarded_port', guest: 8083, host: 8083
  # kafka schema registry port
  config.vm.network 'forwarded_port', guest: 8081, host: 8081
  # kafka broker port
  config.vm.network 'forwarded_port', guest: 9092, host: 9092

  config.vm.network :private_network, type: 'dhcp'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'java'
    chef.add_recipe 'confluent::zookeeper'
    chef.add_recipe 'confluent::kafka'
    chef.add_recipe 'confluent::kafka-connect'
    chef.add_recipe 'confluent::schema-registry'

    chef.json = {
      java: {
        install_flavor: 'oracle',
        jdk_version: '8',
        oracle: {
          accept_oracle_download_terms: true
        }
      },
      confluent: {
        kafka: {
          brokers: 'confluent-berkshelf',
          zookeepers: ['localhost:2181']
        },
        'kafka-connect' => {
          #  Used if you are running kafka services outside of your vagrant node, using the gateway ip to communicate with your host machine
          # 'worker.properties' => {
          #   'bootstrap.servers' => '10.0.2.2:9092',
          #   'key.converter.schema.registry.url' => 'http://10.0.2.2:8081',
          #   'value.converter.schema.registry.url' => 'http://10.0.2.2:8081'
          # }
        }
      }
    }
  end
end
