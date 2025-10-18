require "rails_helper"
require "webmock/rspec"

RSpec.describe Weather::FetchForecast do
#   before { allow(ENV).to receive(:[]).with("OPENWEATHER_API_KEY").and_return("k") }
  before do
    # Allow everything to pass through except the key we’re overriding
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("OPENWEATHER_API_KEY").and_return("k")
  end

  it "parses current/high/low/summary" do
    stub_request(:get, /api.openweathermap.org/).to_return(
      status: 200,
      body: {
        main: { temp: 19.5, temp_max: 22.0, temp_min: 17.0 },
        weather: [{ description: "few clouds" }]
      }.to_json,
      headers: { "Content-Type" => "application/json" }
    )

    res = described_class.call("95014")
    expect(res[:current_temp_c]).to eq(19.5)
    expect(res[:high_c]).to eq(22.0)
    expect(res[:low_c]).to eq(17.0)
    expect(res[:summary]).to eq("few clouds")
  end

  it "returns nil for non-success" do
    stub_request(:get, /api.openweathermap.org/).to_return(status: 503, body: "")
    expect(described_class.call("95014")).to be_nil
  end
end
