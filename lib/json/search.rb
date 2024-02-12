require "json/search/version"
require 'json'
require 'pry'

module Json
  class Search
    class Error < StandardError; end

    attr_reader :field, :file_path

    def initialize(**options)
      @field = options[:field] || "full_name"
      @file_path = options[:file_path] || default_file # File path must be absolute path of the file
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
      parsed_json["data"]
    end

    def parsed_json
      @parsed_json ||= begin
        file = File.read file_path
        json = JSON.parse file

        json
      end
    end

    def default_file
      File.join(File.join(Dir.pwd, '/data/clients.json'))
    end
  end
end
