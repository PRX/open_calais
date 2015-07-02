require File.expand_path(File.dirname(__FILE__) + '/test_helper')

module TestConfig
  extend OpenCalais::Configuration
end

describe OpenCalais::Configuration do

  it "can be configured" do
    TestConfig.configure do |c|
      c.must_be_kind_of OpenCalais::Configuration
    end
  end
end
