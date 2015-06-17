# -*- encoding: utf-8 -*-

require 'rubygems'
require 'open_calais/version'
require 'open_calais/configuration'
require 'open_calais/client'

require 'active_support/all'

module OpenCalais
  extend Configuration

  HEADERS = {
    :license_id                    => 'X-AG-Access-Token',
    :content_type                  => 'Content-Type',
    :output_format                 => 'outputFormat',
    :language                      => 'x-calais-language'
  }

  CONTENT_TYPES = {
    :xml     => 'text/xml',
    :html    => 'text/html',
    :htmlraw => 'text/htmlraw',
    :raw     => 'text/raw'
  }

  OUTPUT_FORMATS = {
    :rdf  => 'xml/rdf',
    :n3   => 'text/n3',
    :json => 'application/json'
  }

  METADATA_SOCIAL_TAGS = 'SocialTags'
  METADATA_GENERIC_RELATIONS = 'GenericRelations'
  METADATA_TYPES  = [METADATA_GENERIC_RELATIONS, METADATA_SOCIAL_TAGS]

  TOPICS          = ['Business_Finance', 'Disaster_Accident', 'Education', 'Entertainment_Culture', 'Environment', 'Health_Medical_Pharma', 'Hospitality_Recreation', 'Human Interest', 'Labor', 'Law_Crime', 'Politics', 'Religion_Belief', 'Social Issues', 'Sports', 'Technology_Internet', 'Weather', 'War_Conflict', 'Other']
  ENTITY_TYPES    = %w(Anniversary City Company Continent Country Currency EmailAddress EntertainmentAwardEvent Facility FaxNumber Holiday IndustryTerm MarketIndex MedicalCondition MedicalTreatment Movie MusicAlbum MusicGroup NaturalFeature OperatingSystem Organization Person PhoneNumber PoliticalEvent Position Product ProgrammingLanguage ProvinceOrState PublishedMedium RadioProgram RadioStation Region SportsEvent SportsGame SportsLeague Technology TVShow TVStation URL)
  GEO_TYPES       = %w(City Continent Country NaturalFeature ProvinceOrState Region)

  DISAMBUGUATIONS = %w(er/Company er/Geo er/Product)
end
