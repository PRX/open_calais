# -*- encoding: utf-8 -*-

module OpenCalais
  class Response
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
      topic.gsub('_', ' and ')
    end

    def importance_to_score(imp)
      case imp
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
          self.topics << {:name => humanize_topic(v.categoryName), :score => v.score, :original => v.categoryName}
        when 'socialTag'
          self.tags << {:name => v.name, :score => importance_to_score(v.importance)}
        when 'entities'
          item = {:guid => k, :name => v.name, :type => v._type}

          instances = Array(v.instances).select{|i| i.exact.downcase != item[:name].downcase }
          item[:matches] = instances if instances && instances.size > 0

          if OpenCalais::GEO_TYPES.include?(v._type)
            if (v.resolutions && v.resolutions.size > 0)
              r = v.resolutions.first
              item[:name]      = r.shortname
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
          item = v.reject_if{|k,v| k[0] == '_' || k == 'instances'}
          item[:type] = v._type
          self.relations << item
        end
      end

      #  remove social tags which are in the topics list already
    end
  end
end