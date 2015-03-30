
include_recipe "java"

# setup confluent group
group node["confluent"]["group"] do
  action :create
end

# setup confluent user
user node["confluent"]["user"] do
  comment "Confluent user"
  gid node["confluent"]["group"]
  shell "/bin/bash"
  home "/home/#{node["confluent"]["user"]}"
  supports :manage_home => true
end

# create confluent install directory
directory node["confluent"]["install_dir"] do
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
end

# Download and unzip the confluent package
package "unzip"

confluent_package = File.join(Chef::Config[:file_cache_path], File.basename(node["confluent"]["artifact_url"]))

remote_file confluent_package do
  source node["confluent"]["artifact_url"]
  backup false
end

bash "unzip confluent package" do
  code <<-EOH
    unzip -q #{confluent_package} -d #{node["confluent"]["install_dir"]}
  EOH

  not_if do
  	File.exists?(File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}"))
  end
end

# Ensure everything is owned by the confluent user/group
execute "chown #{node["confluent"]["user"]}:#{node["confluent"]["group"]} -R #{node["confluent"]["install_dir"]}" do
  action :run
end

# Kafka Rest config files
link "/etc/kafka" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/kafka"
end

# TODO If we make changes here we should restart the service it exists
template "/etc/kafka/server.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["server.properties"]})
  backup false
end

template "/etc/kafka/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["log4j.properties"]})
  backup false
end

# Kafka Rest config files
link "/etc/kafka-rest" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/kafka-rest"
end

# TODO If we make changes here we should restart the service it exists
template "/etc/kafka-rest/kafka-rest.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka-rest"]["kafka-rest.properties"]})
  backup false
end

template "/etc/kafka-rest/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka-rest"]["log4j.properties"]})
  backup false
end

# Schema registry config files
link "/etc/schema-registry" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/schema-registry"
end

# TODO If we make changes here we should restart the service it exists
template "/etc/schema-registry/schema-registry.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["schema-registry"]["schema-registry.properties"]})
  backup false
end

template "/etc/schema-registry/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["schema-registry"]["log4j.properties"]})
  backup false
end