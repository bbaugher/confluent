
include_recipe "confluent::_install"

template "/etc/init.d/kafka-rest" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({
    :name => "kafka-rest",
    :class => "kafkarest.Main",
    :properties_file => "kafka-rest.properties",
    :script => "kafka-rest"
  })
  notifies :restart, "service[kafka-rest]"
end

service "kafka-rest" do
  action [:enable, :start]
end