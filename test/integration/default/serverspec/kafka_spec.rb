# coding: UTF-8

require 'spec_helper'

describe service('kafka') do
  it { should be_running   }
end

# Kafka Rest API
describe port(9092) do
  it { should be_listening }
end
