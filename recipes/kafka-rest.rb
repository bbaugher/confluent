
include_recipe "confluent::_install"

template "/etc/init.d/kafka-rest" do
  source "kafka-rest.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"

  notifies :restart, "service[kafka-rest]"
end

service "kafka-rest" do
  action [:enable, :start]
end