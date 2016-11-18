# coding: UTF-8

require 'spec_helper'

describe service('kafka-connect') do
  it { should be_running   }
end

# Kafka Rest API
describe port(8083) do
  it { should be_listening }
end

describe file('/var/log/confluent/kafka-connect.log') do
  it { should be_file }
end
