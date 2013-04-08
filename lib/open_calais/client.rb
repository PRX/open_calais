require 'open_calais/configuration'
require 'open_calais/connection'
require 'open_calais/response'

module OpenCalais
  class Client

    include Connection

    attr_reader *OpenCalais::Configuration.keys

    attr_accessor :current_options

    class_eval do
      OpenCalais::Configuration.keys.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          self.current_options.merge!({:"#{key}" => arg})
        end
      end
    end

    def initialize(options={}, &block)
      setup(options)
      yield(self) if block_given?
    end

    def setup(options={})
      options = OpenCalais.options.merge(options)
      self.current_options = options
      Configuration.keys.each do |key|
        send("#{key}=", options[key])
      end
    end

    def enrich(text, opts={})
      raise 'Specify a value for the text' unless (text && text.length > 0)

      response = connection.post do |request|
        request.body = text
        OpenCalais::HEADERS.each do |k,v|
          request.headers[v] = opts[k] if opts.key?(k)
        end
      end
      OpenCalais::Response.new(response)
    end
  end

end
