# frozen_string_literal: true

include_recipe 'confluent::_install'
confluent_extracted_dir = "#{node['confluent']['install_dir']}/confluent-#{node['confluent']['version']}"

link '/etc/zookeeper' do
  to "#{confluent_extracted_dir}/etc/kafka"
end

template "#{confluent_extracted_dir}/bin/zookeeper-server-stop" do
  source 'stop.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(
    process_name: 'zookeeper'
  )
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[zookeeper]'
end

template '/etc/zookeeper/zookeeper.properties' do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['zookeeper']['zookeeper.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[zookeeper]'
end

template '/etc/init.d/zookeeper' do
  source 'service.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(
    name: 'zookeeper',
    class: 'zookeeper',
    properties_file: 'zookeeper.properties',
    script: 'zookeeper-server',
    env_vars: {}
  )
  notifies :restart, 'service[zookeeper]'
end

service 'zookeeper' do
  action %i[enable start]
end
