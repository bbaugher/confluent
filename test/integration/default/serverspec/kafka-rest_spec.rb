# coding: UTF-8

require 'spec_helper'

describe service('kafka-rest') do
  it { should be_running   }
end

# Kafka Rest API
describe port(8082) do
  it { should be_listening }
end

describe file('/var/log/confluent/kafka-rest.log') do
  it { should be_file }
end
