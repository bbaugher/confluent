include_recipe "confluent::_install"

template "/etc/init.d/kafka" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({
    :name => "kafka",
    :class => "kafka.Kafka",
    :properties_file => "server.properties",
    :script => "kafka-server",
    :env_vars => node["confluent"]["kafka"]["env_vars"]
  })
  notifies :restart, "service[kafka]"
end

service "kafka" do
  action [:enable, :start]
end
