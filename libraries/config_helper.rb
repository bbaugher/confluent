def set_broker_id
  if node['confluent']['kafka']['server.properties'].key?('broker.id')
    Chef::Log.info(
      "broker hard set to #{node['confluent']['kafka']['server.properties']['broker.id']} "\
      'in server.properties node object'
    )
    return
  end

  brokers = Array(node['confluent']['kafka']['brokers'])

  if brokers.nil?
    Chef::Log.error(
      "node['confluent']['kafka']['brokers'] or "\
      "node['confluent']['kafka']['server.properties']['broker.id'] must be set properly"
    )
  else
    broker_id = brokers.index do |broker|
      broker == node['fqdn'] ||
      broker == node['ipaddress'] ||
      broker == node['hostname']
    end

    if broker_id.nil?
      Chef::Log.error("Unable to find #{node['fqdn']}, #{node['ipaddress']} or "\
                      "#{node['hostname']} in node['kafka']['brokers'] : #{node['confluent']['kafka']['brokers']}"
                     )
    else
      node.default['confluent']['kafka']['server.properties']['broker.id'] = broker_id + 1
      Chef::Log.debug("BROKER SET: #{node['confluent']['kafka']['server.properties']['broker.id']}")
      return
    end
  end

  raise 'Unable to run kafka::default unable to determine broker ID'
end

def set_zookeeper_connect
  if node['confluent']['kafka']['server.properties'].key?('zookeeper.connect')
    Chef::Log.info(
      "broker hard set to '#{node['confluent']['kafka']['server.properties']['zookeeper.connect']}' "\
      'in server.properties node object'
    )
    return
  end

  if node['confluent']['kafka']['zookeepers'].nil?
    Chef::Log.error(
      "node['confluent']['kafka']['zookeepers'] or "\
      "node['confluent']['kafka']['server.properties']['zookeepers.connect'] must be set properly"
    )
  else
    zk_connect = Array(node['confluent']['kafka']['zookeepers']).join ','
    zk_connect += node['confluent']['kafka']['zookeeper_chroot'] if node['confluent']['kafka']['zookeeper_chroot']
    node.default['confluent']['kafka']['server.properties']['zookeeper.connect'] = zk_connect
    return
  end

  raise 'Unable to run kafka::default unable to determine zookeeper hosts'
end
