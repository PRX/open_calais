require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe OpenCalais do

  it "has default configuration options" do
    _(OpenCalais.options).wont_be_nil
    _(OpenCalais.options[:adapter]).must_equal OpenCalais::Configuration::DEFAULT_ADAPTER
  end

  it "can be configured" do
    _(OpenCalais).must_respond_to(:configure)

    _(OpenCalais.api_key).must_be_nil

    OpenCalais.configure do |c|
      _(c).must_equal OpenCalais
      c.api_key = "this is a test key"
    end

    _(OpenCalais.api_key).must_equal "this is a test key"

    _(OpenCalais.options[:api_key]).must_equal "this is a test key"
  end
end
