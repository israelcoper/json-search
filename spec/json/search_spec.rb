RSpec.describe Json::Search do
  it "has a version number" do
    expect(Json::Search::VERSION).not_to be nil
  end

  context "Instance methods" do
    subject { described_class.new }

    describe "#search" do
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
  end
end
