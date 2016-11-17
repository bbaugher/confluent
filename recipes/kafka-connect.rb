include_recipe "confluent::_install"

confluent_extracted_dir = File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}")
connect_jdbc_jar_dir = File.join confluent_extracted_dir, 'share/java/kafka-connect-jdbc' #TODO make this just kafka-connect-common

directory "#{confluent_extracted_dir}/etc/kafka-connect" do
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  action :create
end

link "/etc/kafka-connect" do
  to "#{confluent_extracted_dir}/etc/kafka-connect"
end

# Drops in any jars a remote url was provided for
node["confluent"]["kafka-connect"]["jar_urls"].each do |kafka_connect_jar_url|
  file_name = File.basename(kafka_connect_jar_url)
  remote_file "#{connect_jdbc_jar_dir}/#{file_name}" do
    source kafka_connect_jar_url
    owner node["confluent"]["user"]
    group node["confluent"]["group"]
    mode "755"
    action :create_if_missing
    backup false
    notifies :restart, "service[kafka-connect]"
  end
end

# writes a properties file to be utilized by the connect worker
template "/etc/kafka-connect/#{node["confluent"]["kafka-connect"]["worker_properties_file_name"]}" do
  source 'properties.erb'
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables(properties: node["confluent"]["kafka-connect"]["worker.properties"])
  backup false
  notifies :restart, "service[kafka-connect]"
end

# Allows for easily writing custom jdbc connector properties files at deployment time instead of via the rest api
node["confluent"]["kafka-connect"]["properties_files"].each do |property_file_name, properties|
  template "etc/kafka-connect/#{property_file_name}" do
    source 'properties.erb'
    owner node["confluent"]["user"]
    group node["confluent"]["group"]
    mode "755"
    variables(properties: properties)
    backup false
    notifies :restart, "service[kafka-connect]"
  end
end

template "#{confluent_extracted_dir}/etc/kafka/connect-log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables(properties: node["confluent"]["kafka-connect"]["log4j.properties"])
  backup false
  notifies :restart, "service[kafka-connect]"
end

template "#{confluent_extracted_dir}/bin/kafka-connect-start" do
  source 'kafka-connect-start.erb'
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  backup false
  notifies :restart, "service[kafka-connect]"
end

template "#{confluent_extracted_dir}/bin/kafka-connect-stop" do
  source 'kafka-connect-start.erb'
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  backup false
  notifies :restart, "service[kafka-connect]"
end

template "/etc/init.d/kafka-connect" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables(
    name: "kafka-connect",
    class: node["confluent"]["kafka-connect"]["class"],
    properties_file: node["confluent"]["kafka-connect"]["worker_properties_file_name"],
    script: "kafka-connect",
    env_vars: node["confluent"]["kafka-connect"]["env_vars"]
  )
  notifies :restart, "service[kafka-connect]"
end

service "kafka-connect" do
  action [:enable, :start]
end
