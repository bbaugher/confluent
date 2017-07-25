# frozen_string_literal: true

include_recipe 'confluent::_install'
connect_class = node['confluent']['kafka-connect']['distributed_mode'] ? node['confluent']['kafka-connect']['distributed_class'] : node['confluent']['kafka-connect']['standalone_class']

confluent_extracted_dir = File.join(node['confluent']['install_dir'], "confluent-#{node['confluent']['version']}")
connect_share_dir = File.join confluent_extracted_dir, 'share', 'java', 'kafka-connect-all'

apply_kerberos_config('kafka-connect', 'KAFKA_OPTS')

directory "#{confluent_extracted_dir}/etc/kafka-connect" do
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
end

directory connect_share_dir do
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
end

link '/etc/kafka-connect' do
  to "#{confluent_extracted_dir}/etc/kafka-connect"
end

# Drops in any jars a remote url was provided for
node['confluent']['kafka-connect']['jar_urls'].each do |kafka_connect_jar_url|
  file_name = File.basename(kafka_connect_jar_url)
  remote_file "#{connect_share_dir}/#{file_name}" do
    source kafka_connect_jar_url
    owner node['confluent']['user']
    group node['confluent']['group']
    mode '755'
    action :create_if_missing
    backup node['confluent']['backup_templates']
    notifies :restart, 'service[kafka-connect]'
  end
end

ruby_block 'Clean unreferenced Kafka Connect jars' do
  block do
    configured_jar_files = node['confluent']['kafka-connect']['jar_urls'].map { |url| File.basename(url) }
    all_jar_files = Dir.entries(connect_share_dir)
                       .reject { |file| file == '.' || file == '..' }

    jar_files_to_remove = all_jar_files - configured_jar_files

    jar_files_to_remove.each do |file|
      Chef::Log.info("Removing file [#{file}] from connect share directory as its no longer configured in jar_urls")
      File.delete(File.join(connect_share_dir, file))
    end
  end
end

# writes a properties file to be utilized by the connect worker
template "/etc/kafka-connect/#{node['confluent']['kafka-connect']['worker_properties_file_name']}" do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['kafka-connect']['worker.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-connect]'
end

# Allows for easily writing custom jdbc connector properties files at deployment time instead of via the rest api
node['confluent']['kafka-connect']['properties_files'].each do |property_file_name, properties|
  # Must use real directory instead of symblink
  template "#{confluent_extracted_dir}/etc/kafka-connect/#{property_file_name}" do
    source 'properties.erb'
    owner node['confluent']['user']
    group node['confluent']['group']
    mode '755'
    variables(properties: properties)
    backup node['confluent']['backup_templates']
    notifies :restart, 'service[kafka-connect]'
  end
end

template "#{confluent_extracted_dir}/etc/kafka/connect-log4j.properties" do
  source 'properties.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(properties: node['confluent']['kafka-connect']['log4j.properties'])
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-connect]'
end

template "#{confluent_extracted_dir}/bin/kafka-connect-start" do
  source 'kafka-connect-start.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-connect]'
end

template "#{confluent_extracted_dir}/bin/kafka-connect-stop" do
  source 'stop.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(
    process_name: connect_class
  )
  backup node['confluent']['backup_templates']
  notifies :restart, 'service[kafka-connect]'
end

template '/etc/init.d/kafka-connect' do
  source 'service.erb'
  owner node['confluent']['user']
  group node['confluent']['group']
  mode '755'
  variables(
    name: 'kafka-connect',
    class: connect_class,
    properties_file: node['confluent']['kafka-connect']['worker_properties_file_name'],
    script: 'kafka-connect',
    env_vars: node['confluent']['kafka-connect']['env_vars']
  )
  notifies :restart, 'service[kafka-connect]'
end

service 'kafka-connect' do
  action %i[enable start]
  if node['confluent']['kerberos']['enable']
    subscribes :restart, "template[#{node['confluent']['install_dir']}/confluent-#{node['confluent']['version']}/jaas.conf]"
  end
end
