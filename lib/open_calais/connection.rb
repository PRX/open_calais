# -*- encoding: utf-8 -*-

require 'faraday_middleware'

module OpenCalais
  module Connection

    ALLOWED_OPTIONS = [
      :headers,
      :url,
      :params,
      :request,
      :ssl
    ].freeze

    def merge_default_options(opts={})
      headers = opts.delete(:headers) || {}
      options = {
        :headers => {
          # generic http headers
          'User-Agent'   => user_agent,
          'Accept'       => "#{OpenCalais::OUTPUT_FORMATS[:json]};charset=utf-8",

          # open calais default headers
          OpenCalais::HEADERS[:license_id]    => api_key,
          OpenCalais::HEADERS[:content_type]  => OpenCalais::CONTENT_TYPES[:raw],
          OpenCalais::HEADERS[:output_format] => OpenCalais::OUTPUT_FORMATS[:json],
          OpenCalais::HEADERS[:language]      => 'English'
        },
        :ssl => {:verify => false},
        :url => endpoint
      }.merge(opts)
      options[:headers] = options[:headers].merge(headers)
      OpenCalais::HEADERS.each{|k,v| options[:headers][v] = options.delete(k) if options.key?(k)}
      options.select{|k,v| ALLOWED_OPTIONS.include?(k.to_sym)}
    end

    def connection(options={})
      opts = merge_default_options(options)
      Faraday::Connection.new(opts) do |connection|
        connection.request  :url_encoded
        connection.response :mashify
        connection.response :logger if ENV['DEBUG']

        if opts[:headers][OpenCalais::HEADERS[:output_format]] == OpenCalais::OUTPUT_FORMATS[:json]
          connection.response :json
        else
          connection.response :xml
        end

        connection.adapter(adapter)
      end

    end
  end
end
