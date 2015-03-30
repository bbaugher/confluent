# coding: UTF-8

require 'spec_helper'

describe user('confluent') do
  it { should exist }
  it { should belong_to_group 'confluent' }
end

describe service('kafka-rest') do
  it { should be_running   }
end

# Kafka Rest API
describe port(8082) do
  it { should be_listening }
end