# coding: UTF-8
# frozen_string_literal: true

require 'spec_helper'

describe file('/opt/confluent/confluent-2.0.1/etc/kafka-connect') do
  it { should be_directory }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/opt/confluent/confluent-2.0.1/share/java/kafka-connect-all') do
  it { should be_directory }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/etc/kafka-connect') do
  it { should be_directory }
  it { should be_linked_to '/opt/confluent/confluent-2.0.1/etc/kafka-connect' }
end

describe file('/opt/confluent/confluent-2.0.1/share/java/kafka-connect-all/chef-project-1.8.1-tests.jar') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/opt/confluent/confluent-2.0.1/share/java/kafka-connect-all/my.jar') do
  it { should_not exist }
end

describe file('/etc/kafka-connect/test_worker.properties') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
  it { should contain('worker_test.property=test') }
end

describe file('/etc/kafka-connect/test_file.properties') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
  it { should contain('test.property=test') }
end

describe file('/opt/confluent/confluent-2.0.1/etc/kafka/connect-log4j.properties') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
  it { should contain('log4j.test.property=test') }
end

describe file('/var/log/confluent/kafka-connect.log') do
  it { should be_file }
end

describe file('/opt/confluent/confluent-2.0.1/bin/kafka-connect-start') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/opt/confluent/confluent-2.0.1/bin/kafka-connect-stop') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe file('/etc/init.d/kafka-connect') do
  it { should be_file }
  it { should be_owned_by 'confluent' }
  it { should be_grouped_into 'confluent' }
  it { should be_mode 755 }
end

describe service('kafka-connect') do
  it { should be_running   }
end

# Kafka Connect API
describe port(8083) do
  it { should be_listening }
end
