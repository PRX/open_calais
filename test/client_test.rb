require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe OpenCalais::Client do

  it "is initialized with defaults" do
    oc = OpenCalais::Client.new
    _(oc.current_options).wont_be_nil
    _(oc.current_options).must_equal OpenCalais.options
  end

  it "is initialized with specific values" do
    oc = OpenCalais::Client.new(:api_key => 'current')
    _(oc.current_options).wont_be_nil
    _(oc.current_options).wont_equal OpenCalais.options
    _(oc.current_options[:api_key]).must_equal 'current'
    _(oc.api_key).must_equal 'current'
  end

  it "gets tags for text" do
    oc = OpenCalais::Client.new(:api_key => ENV['OPEN_CALAIS_KEY'])
    response = oc.enrich("Ruby on Rails is a fantastic web framework. It uses MVC, and the ruby programming language invented by Matz")
    _(response).wont_be_nil
    _(response.raw).wont_be_nil
  end

  it "passes in header options in client" do
    oc = OpenCalais::Client.new(:api_key => ENV['OPEN_CALAIS_KEY'], :content_type => OpenCalais::CONTENT_TYPES[:html])
    response = oc.enrich("Ruby on Rails is a fantastic web framework. It uses MVC, and the ruby programming language invented by Matz")
    _(response).wont_be_nil
    _(response.raw).wont_be_nil
  end

  it "passes in header optionsin enrich" do
    oc = OpenCalais::Client.new(:api_key => ENV['OPEN_CALAIS_KEY'])
    response = oc.enrich("Ruby on Rails is a fantastic web framework. It uses MVC, and the ruby programming language invented by Matz", :headers => {:content_type => OpenCalais::CONTENT_TYPES[:html]})
    _(response).wont_be_nil
    _(response.raw).wont_be_nil
  end
end
