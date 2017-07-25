
# frozen_string_literal: true

include_recipe 'confluent::_install'

apply_kerberos_config('schema-registry', 'SCHEMA_REGISTRY_OPTS')

template '/etc/schema-registry/schema-registry.properties' do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['schema-registry']['schema-registry.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[schema-registry]'
end

template '/etc/schema-registry/log4j.properties' do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['schema-registry']['log4j.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[schema-registry]'
end

template '/etc/init.d/schema-registry' do
  source 'service.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(name: 'schema-registry',
            class: node['confluent']['schema-registry']['class'],
            properties_file: 'schema-registry.properties',
            script: 'schema-registry',
            env_vars: node['confluent']['schema-registry']['env_vars'])
  notifies :restart, 'service[schema-registry]'
end

service 'schema-registry' do
  action %i[enable start]
  if node['confluent']['kerberos']['enable']
    subscribes :restart, "template[#{node['confluent']['install_dir']}/confluent-#{node['confluent']['version']}/jaas.conf]"
  end
end
