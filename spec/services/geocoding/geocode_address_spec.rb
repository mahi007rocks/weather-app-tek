require "rails_helper"

RSpec.describe Geocoding::GeocodeAddress do
  it "returns postal_code when geocoder finds one" do
    fake = double("result", postal_code: "95014")
    allow(Geocoder).to receive(:search).and_return([fake])
    expect(described_class.call("1 Apple Park Way")).to eq("95014")
  end

  it "returns nil on errors" do
    allow(Geocoder).to receive(:search).and_raise(StandardError.new("boom"))
    expect(described_class.call("whatever")).to be_nil
  end
end
