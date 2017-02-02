include_recipe "java"

# setup confluent group
group node["confluent"]["group"] do
  gid node['confluent']['gid'] if node['confluent']['gid']
  action :create
end

# setup confluent user
user node["confluent"]["user"] do
  uid node['confluent']['uid'] if node['confluent']['uid']
  comment "Confluent service user"
  gid node["confluent"]["group"]
  shell '/bin/false'
  system true
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

start_file = File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}", "bin", "kafka-server-start")
template start_file do
  source 'kafka-server-start.erb'
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  # There is a bug in 1.0 where kafka-server-start uses the wrong log4j.properties file when running kafka
  not_if { node["confluent"]["version"] == "1.0" }
end

cookbook_file "kafka-server-stop" do
  path File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}", "bin", "kafka-server-stop")
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  # There is a bug in 2.0.0/2.0.1 where kafka-server-stop uses the looks for the wrong class to stop the process
  only_if { node["confluent"]["version"] == "2.0.0" || node["confluent"]["version"] == "2.0.1" }
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

# Schema registry config files
link "/etc/schema-registry" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/schema-registry"
end
