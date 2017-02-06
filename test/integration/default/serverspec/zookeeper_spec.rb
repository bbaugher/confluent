# coding: UTF-8
# frozen_string_literal: true

require 'spec_helper'

describe file('/etc/zookeeper') do
  it { should be_directory }
  it { should be_linked_to '/opt/confluent/confluent-2.0.1/etc/kafka' }
end

describe file('/opt/confluent/confluent-2.0.1/bin/zookeeper-server-stop') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/etc/init.d/zookeeper') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe service('zookeeper') do
  it { should be_running   }
end

# Kafka Connect API
describe port(8083) do
  it { should be_listening }
end
