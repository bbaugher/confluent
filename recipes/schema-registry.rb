
include_recipe "confluent::_install"

template "/etc/init.d/schema-registry" do
  source "service.erb"
  owner node["confluent"]["user"]
  group node["confluent"]["group"]
  mode "755"
  variables({
    :name => "schema-registry",
    :class => "io.confluent.kafka.schemaregistry.rest.Main"
  })
  notifies :restart, "service[schema-registry]"
end

service "schema-registry" do
  action [:enable, :start]
end