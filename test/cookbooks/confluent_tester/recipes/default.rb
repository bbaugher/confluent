
confluent_dir = File.join(node["confluent"]["install_dir"], "confluent-#{node["confluent"]["version"]}")

zookeeper_bin = File.join(confluent_dir, "bin", "zookeeper-server-start")
zookeeper_config = File.join(confluent_dir, "etc", "kafka", "zookeeper.properties")

include_recipe "confluent"

bash "start zookeeper" do
  code <<-EOH
    #{zookeeper_bin} #{zookeeper_config} &
  EOH
end