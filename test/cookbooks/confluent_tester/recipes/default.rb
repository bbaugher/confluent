
confluent_dir = File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}")
kafka_bin = File.join(confluent_dir, "bin", "kafka-server-start")
kafka_config = File.join(confluent_dir, "etc", "kafka", "server.properties")

include_recipe "confluent"

bash "start kafka broker" do
  code <<-EOH
    #{kafka_bin} -daemon #{kafka_config}
  EOH
end