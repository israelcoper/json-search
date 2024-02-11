require "json/search/version"
require 'json'
require 'pry'

module Json
  class Search
    class Error < StandardError; end

    def search(keyword)
      collection.select {|hash| hash["full_name"]&.downcase =~ /#{keyword}/}
    end

    private

    def collection
      parsed_json["data"]
    end

    def parsed_json
      @parsed_json ||= begin
        path = File.join(File.join(Dir.pwd, '/data/clients.json'))
        file = File.read path
        json = JSON.parse file

        json
      end
    end
  end
end
