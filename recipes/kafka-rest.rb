
# frozen_string_literal: true

include_recipe 'confluent::_install'

apply_kerberos_config('kafka-rest', 'KAFKAREST_OPTS')

# Kafka Rest config files
link '/etc/kafka-rest' do
  to "#{node['confluent']['install_dir']}/confluent-#{node['confluent']['version']}/etc/kafka-rest"
end

template '/etc/kafka-rest/kafka-rest.properties' do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['kafka-rest']['kafka-rest.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-rest]'
end

template '/etc/kafka-rest/log4j.properties' do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['kafka-rest']['log4j.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-rest]'
end

template '/etc/init.d/kafka-rest' do
  source 'service.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(name: 'kafka-rest',
            class: node['confluent']['kafka-rest']['class'],
            properties_file: 'kafka-rest.properties',
            script: 'kafka-rest',
            env_vars: node['confluent']['kafka-rest']['env_vars'])
  notifies :restart, 'service[kafka-rest]'
end

service 'kafka-rest' do
  action %i[enable start]
  if node['confluent']['kerberos']['enable']
    subscribes :restart, "template[#{node['confluent']['install_dir']}/confluent-#{node['confluent']['version']}/jaas.conf]"
  end
end
