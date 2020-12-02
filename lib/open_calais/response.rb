# -*- encoding: utf-8 -*-

require 'active_support'

module OpenCalais
  class Response

    ALLOWED_OPTIONS = [
      :ignore_literal_match
    ].freeze

    include ActiveSupport::Inflector
    attr_accessor :raw, :language, :topics, :tags, :entities, :relations, :locations

    def initialize(response, options={})
      @options = merge_default_options(options)
      @raw  = response

      @language = 'English'
      @topics    = []
      @tags      = []
      @entities  = []
      @relations = []
      @locations = []

      parse(response, @options)
    end

    def merge_default_options(opts={})
      defaults = {
        :ignore_literal_match => true
      }
      options = defaults.merge(opts)
      options.select{ |k,v| ALLOWED_OPTIONS.include? k.to_sym }
    end

    def humanize_topic(topic)
      transliterate(topic.gsub('_', ' & ').titleize)
    end

    def importance_to_score(imp)
      case imp.to_i
      when 1 then 0.9
      when 2 then 0.7
      else 0.5
      end
    end

    def parse(response, options={})
      r = response.body
      @language = r.doc.meta.language rescue nil
      @language = nil if @language == 'InputTextTooShort'

      r.each do |k,v|
        case v._typeGroup
        when 'topics'
          self.topics << {
            :name => humanize_topic(v.name),
            :score => v.score.to_f,
            :original => v.name
          }
        when 'socialTag'
          self.tags << {
            :name => v.name.gsub('_', ' and ').downcase,
            :score => importance_to_score(v.importance)
          }
        when 'entities'
          parse_entity(k, v, options)
        when 'relations'
          parse_relation(k, v, options)
        end
      end

      # remove social tags which are in the topics list already
      topic_names = self.topics.collect { |topic| topic[:name].downcase }
      self.tags.delete_if { |tag| topic_names.include?(tag[:name]) }
    end

    def parse_entity(k, v, options)
      if v.name.nil?
        v.name = v.instances.first[:exact]
      end

      item = {
        :guid => k,
        :name => v.name,
        :type => transliterate(v._type).titleize,
        :score => v.relevance
      }

      instances = Array(v.instances)
      if options[:ignore_literal_match]
        instances = instances.select { |i| i.exact.downcase != item[:name].downcase }
      end
      item[:matches] = instances unless instances.empty?

      if OpenCalais::GEO_TYPES.include?(v._type)
        item = set_location_info(item, v)
        self.locations << item
      else
        self.entities << item
      end
    end

    def set_location_info(item, v)
      return item if v.resolutions.nil? || v.resolutions.empty?

      r = v.resolutions.first
      item[:name]      = r.shortname || r.name
      item[:latitude]  = r.latitude
      item[:longitude] = r.longitude
      item[:country]   = r.containedbycountry if r.containedbycountry
      item[:state]     = r.containedbystate if r.containedbystate
      item
    end

    def parse_relation(k, v, _options)
      item = v.reject { |key,val| key[0] == '_' || key == 'instances' } || {}
      item[:type] = transliterate(v._type).titleize
      self.relations << item
    end
  end
end
