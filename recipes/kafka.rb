include_recipe "confluent::_install"

set_broker_id
set_zookeeper_connect

template "/etc/kafka/server.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["server.properties"]})
  backup false
  notifies :restart, "service[kafka]"
end

template "/etc/kafka/log4j.properties" do
  source "properties.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({:properties => node["confluent"]["kafka"]["log4j.properties"]})
  backup false
  notifies :restart, "service[kafka]"
end

template "/etc/init.d/kafka" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({
    :name => "kafka",
    :class => node["confluent"]["kafka"]["class"],
    :properties_file => "server.properties",
    :script => "kafka-server",
    :env_vars => node["confluent"]["kafka"]["env_vars"]
  })
  notifies :restart, "service[kafka]"
end

service "kafka" do
  action [:enable, :start]
end
