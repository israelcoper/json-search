RSpec.describe Json::Search do
  it "has a version number" do
    expect(Json::Search::VERSION).not_to be nil
  end

  context "Instance methods" do
    let(:file_path) { File.join(File.join(Dir.pwd, '/data/clients.json')) }
    let(:file) { File.read(file_path) }
    let(:json) { JSON.parse(file) }

    subject { described_class.new }

    describe "#search" do
      describe "default field" do
        it "returns entire collection" do
          expect(subject.search).to match_array json["data"]
        end

        it "returns empty array" do
          expect(subject.search('madagascar')).to eq []
        end

        it "returns partially match keyword" do
          expect(subject.search('jane')).to eq [
            {"id"=>2, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"},
            {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}
          ]
        end
      end

      describe "dynamic field" do
        subject { described_class.new(field: "email") }

        it "returns entire collection" do
          expect(subject.search).to match_array json["data"]
        end

        it "returns empty array" do
          expect(subject.search('madagascar.com')).to eq []
        end

        it "returns partially match keyword" do
          expect(subject.search('aol.com')).to eq [
            { "id"=>5, "full_name"=>"Emily Brown", "email"=>"emily.brown@aol.com" }
          ]
        end
      end

      describe "dynamic file" do
        let(:file_path) { File.join(File.join(Dir.pwd, '/data/records.json')) }
        let(:file) { File.read(file_path) }
        let(:json) { JSON.parse(file) }

        subject { described_class.new(field: "id", file_path: file_path) }

        it "returns entire collection" do
          expect(subject.search).to match_array json["data"]
        end

        it "returns empty array" do
          expect(subject.search(10)).to eq []
        end

        it "returns partially match keyword" do
          expect(subject.search(3)).to eq [
            { "id"=>3, "full_name"=>"Eureka Seven", "email"=>"eureka.seven@crunchyroll.com" }
          ]
        end
      end

      describe "url" do
        let(:url) { "https://swapi.dev/api/planets" }
        let(:json) { JSON.parse(URI.open(url).read) }

        subject { described_class.new(url: url, field: "climate") }

        it "returns entire collection" do
          expect(subject.search).to match_array json["results"]
        end

        it "returns empty array" do
          expect(subject.search("madagascar")).to eq []
        end

        it "returns partially match keyword" do
          expect(subject.search("frozen")[0]["climate"]).to eq json["results"][3]["climate"]
        end
      end
    end

    describe "#duplicate_email" do
      it "returns any records with the same email" do
        expect(subject.duplicate_email).to eq [
          {"id"=>2, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"},
          {"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}
        ]
      end
    end
  end
end
