
# Schema registry config files
link "/etc/schema-registry" do
  to "#{node["confluent"]["install_dir"]}/confluent-#{node["confluent"]["version"]}/etc/schema-registry"
end

# TODO If we make changes here we should restart the service it exists
template "/etc/schema-registry/kafka-rest.properties" do
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