
# frozen_string_literal: true

confluent_dir = File.join(node['confluent']['install_dir'], "confluent-#{node['confluent']['version']}")

zookeeper_bin = File.join(confluent_dir, 'bin', 'zookeeper-server-start')
zookeeper_config = File.join(confluent_dir, 'etc', 'kafka', 'zookeeper.properties')

include_recipe 'confluent'

bash 'start zookeeper' do
  code <<-EOH
    #{zookeeper_bin} #{zookeeper_config} &
  EOH
end

share_dir = File.join(confluent_dir, 'share', 'java/kafka-connect-all')

directory share_dir do
  mode '0755'
  owner node['confluent']['user']
  group node['confluent']['group']
end

# For connect testing
file File.join(share_dir, 'my.jar') do
  content 'value'
  mode '0755'
  owner node['confluent']['user']
  group node['confluent']['group']
end
