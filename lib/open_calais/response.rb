# -*- encoding: utf-8 -*-

require 'active_support'

module OpenCalais
  class Response

    include ActiveSupport::Inflector
    attr_accessor :raw, :language, :topics, :tags, :entities, :relations, :locations

    def initialize(response)
      @raw  = response

      @language = 'English'
      @topics    = []
      @tags      = []
      @entities  = []
      @relations = []
      @locations = []

      parse(response)
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

    def parse(response)
      r = response.body
      @language = r.doc.meta.language rescue nil
      @language = nil if @language == 'InputTextTooShort'

      r.each do |k,v|
        case v._typeGroup
        when 'topics'
          self.topics << {:name => humanize_topic(v.name), :score => v.score.to_f, :original => v.name}
        when 'socialTag'
          self.tags << {:name => v.name.gsub('_', ' and ').downcase, :score => importance_to_score(v.importance)}
        when 'entities'
          item = {:guid => k, :name => v.name, :type => transliterate(v._type).titleize, :score => v.relevance}

          instances = Array(v.instances).select{|i| i.exact.downcase != item[:name].downcase }
          item[:matches] = instances if instances && instances.size > 0

          if OpenCalais::GEO_TYPES.include?(v._type)
            if (v.resolutions && v.resolutions.size > 0)
              r = v.resolutions.first
              item[:name]      = r.shortname || r.name
              item[:latitude]  = r.latitude
              item[:longitude] = r.longitude
              item[:country]   = r.containedbycountry if r.containedbycountry
              item[:state]     = r.containedbystate if r.containedbystate
            end
            self.locations << item
          else
            self.entities << item
          end
        when 'relations'
          item = v.reject{|key,val| key[0] == '_' || key == 'instances'} || {}
          item[:type] = transliterate(v._type).titleize
          self.relations << item
        end
      end

      # remove social tags which are in the topics list already
      topic_names = self.topics.collect{|topic| topic[:name].downcase}
      self.tags.delete_if{|tag| topic_names.include?(tag[:name]) }
    end
  end
end
