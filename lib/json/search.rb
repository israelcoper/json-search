require "json/search/version"
require 'json'
require "open-uri"
require 'pry'

module Json
  class Search
    class Error < StandardError; end

    attr_reader :field, :source

    def initialize(**options)
      options.transform_keys!(&:to_sym)

      @field = options[:field] || "full_name"
      # Expect a valid url
      # IF both source are provided, url have the high priority
      # File path must be absolute path of the file
      @source = options[:url] || options[:file_path] || default_source
    end

    def search(keyword = nil)
      return collection if keyword.nil?

      collection.select do |hash|
        return [] unless hash.has_key?(field)

        hash[field]&.to_s&.downcase =~ /#{keyword}/
      end
    end

    def duplicate_email
      emails = collection.map(&:values).flatten

      collection.inject([]) do |array, hash|
        array << hash if emails.select { |email| email == hash["email"] }.size > 1

        array
      end
    end

    private

    def collection
      parsed_json["data"] || parsed_json["results"] # Always expecting a JSON response having either "data" or "results" attribute
    end

    def parsed_json
      @parsed_json ||= begin
        json = URI.open(source).read

        JSON.parse(json)
      end
    end

    def default_source
      File.join(File.join(Dir.pwd, '/data/clients.json'))
    end
  end
end
