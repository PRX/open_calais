# -*- encoding: utf-8 -*-

module OpenCalais
  module Configuration

    VALID_OPTIONS_KEYS = [
      :api_key,
      :adapter,
      :endpoint,
      :user_agent
    ].freeze

    # this you need to get from open calais - go register!
    DEFAULT_API_KEY = nil

    # Adapters are whatever Faraday supports - I like excon alot, so I'm defaulting it
    DEFAULT_ADAPTER = :excon

    # The api endpoint to get REST info from opencalais
    DEFAULT_ENDPOINT = 'https://api.thomsonreuters.com/permid/calais'.freeze

    # The value sent in the http header for 'User-Agent' if none is set
    DEFAULT_USER_AGENT = "OpenCalais Ruby Gem #{OpenCalais::VERSION}".freeze

    attr_accessor *VALID_OPTIONS_KEYS

    # Convenience method to allow for global setting of configuration options
    def configure
      yield self
    end

    def self.extended(base)
      base.reset!
    end

    class << self
      def keys
        VALID_OPTIONS_KEYS
      end
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    # Reset configuration options to their defaults
    def reset!
      self.api_key       	    = DEFAULT_API_KEY
      self.adapter            = DEFAULT_ADAPTER
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end
  end
end
