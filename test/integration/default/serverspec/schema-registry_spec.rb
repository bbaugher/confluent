# coding: UTF-8
# frozen_string_literal: true

require 'spec_helper'

describe service('schema-registry') do
  it { should be_running   }
end

# Schema Registry API
describe port(8081) do
  it { should be_listening }
end

describe file('/var/log/confluent/schema-registry.log') do
  it { should be_file }
end
