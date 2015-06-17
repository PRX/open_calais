require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe OpenCalais do

  it "has default configuration options" do
    OpenCalais.options.wont_be_nil
    OpenCalais.options[:adapter].must_equal OpenCalais::Configuration::DEFAULT_ADAPTER
  end

  it "can be configured" do
    OpenCalais.must_respond_to(:configure)

    OpenCalais.api_key.must_be_nil

    OpenCalais.configure do |c|
      c.must_equal OpenCalais
      c.api_key = "this is a test key"
    end

    OpenCalais.api_key.must_equal "this is a test key"

    OpenCalais.options[:api_key].must_equal "this is a test key"
  end
end
