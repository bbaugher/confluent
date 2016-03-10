
include_recipe "confluent::_install"

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
  notifies :restart, "service[kafka-rest]"
end

template "/etc/kafka-rest/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka-rest"]["log4j.properties"]})
  backup false
  notifies :restart, "service[kafka-rest]"
end

template "/etc/init.d/kafka-rest" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({
    :name => "kafka-rest",
    :class => node["confluent"]["kafka-rest"]["class"],
    :properties_file => "kafka-rest.properties",
    :script => "kafka-rest",
    :env_vars => node["confluent"]["kafka-rest"]["env_vars"]
  })
  notifies :restart, "service[kafka-rest]"
end

service "kafka-rest" do
  action [:enable, :start]
end
