
include_recipe "java"

# setup confluent group
group node["confluent"]["group"] do
  gid node['confluent']['uid'] if node['confluent']['uid'].exists?
  action :create
end

# setup confluent user
user node["confluent"]["user"] do
  uid node['confluent']['uid'] if node['confluent']['uid'].exists?
  comment "Confluent service user"
  gid node["confluent"]["group"]
  shell   '/bin/false'
  system  true
end

# create confluent install directory
directory node["confluent"]["install_dir"] do
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
end

directory "/var/log/confluent" do
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

execute "unzip -q #{confluent_package} -d #{node["confluent"]["install_dir"]}" do
  not_if do
  	File.exists?(File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}"))
  end
end

cookbook_file "kafka-server-start" do
  path File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}", "bin", "kafka-server-start")
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  # There is a bug in 1.0 where kafka-server-start uses the wrong log4j.properties file when running kafka
  not_if { node["confluent"]["version"] == "1.0" }
  backup false
end

# Ensure everything is owned by the confluent user/group
execute "chown #{node["confluent"]["user"]}:#{node["confluent"]["group"]} -R #{node["confluent"]["install_dir"]}" do
  action :run
end

# Kafka Rest config files
link "/etc/kafka" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/kafka"
end

template "/etc/kafka/server.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["server.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::kafka]")
    notifies :restart, "service[kafka]"
  end
end

template "/etc/kafka/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["log4j.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::kafka]")
    notifies :restart, "service[kafka]"
  end
end

# Kafka Rest config files
link "/etc/kafka-rest" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/kafka-rest"
end

template "/etc/kafka-rest/kafka-rest.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka-rest"]["kafka-rest.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::kafka-rest]")
    notifies :restart, "service[kafka-rest]"
  end
end

template "/etc/kafka-rest/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka-rest"]["log4j.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::kafka-rest]")
    notifies :restart, "service[kafka-rest]"
  end
end

# Schema registry config files
link "/etc/schema-registry" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/schema-registry"
end

template "/etc/schema-registry/schema-registry.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["schema-registry"]["schema-registry.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::schema-registry]")
    notifies :restart, "service[schema-registry]"
  end
end

template "/etc/schema-registry/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["schema-registry"]["log4j.properties"]})
  backup false

  if node.run_list.include?("recipe[confluent::schema-registry]")
    notifies :restart, "service[schema-registry]"
  end
end
