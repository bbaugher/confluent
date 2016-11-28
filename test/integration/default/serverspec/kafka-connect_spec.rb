# coding: UTF-8

require 'spec_helper'

describe service('kafka-connect') do
  it { should be_running   }
end

# Kafka Connect API
describe port(8083) do
  it { should be_listening }
end

describe file('/etc/kafka-connect') do
  it { should be_directory }
end

describe file('/var/log/confluent/kafka-connect.log') do
  it { should be_file }
end

describe file('/opt/confluent/confluent-2.0.1/etc/kafka/connect-log4j.properties') do
  it { should be_file }
  it { should contain('log4j.test.property=test') }
end

describe file('/etc/kafka-connect/test_file.properties') do
  it { should be_file }
  it { should contain('test.property=test') }
end

describe file('/opt/confluent/confluent-2.0.1/share/java/kafka-connect-all/sqljdbc41.jar') do
  it { should be_file }
end
