# coding: UTF-8
# frozen_string_literal: true

require 'spec_helper'

describe user('confluent') do
  it { should exist }
  it { should belong_to_group 'confluent' }
end
