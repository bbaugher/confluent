# coding: UTF-8

require 'spec_helper'

describe user('confluent') do
  it { should exist }
  it { should belong_to_group 'confluent' }
end