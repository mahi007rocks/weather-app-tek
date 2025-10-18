require "rails_helper"
require "webmock/rspec"

RSpec.describe "Forecasts", type: :request do
  describe "POST /forecasts" do
    let(:address) { "1 Apple Park Way, Cupertino, CA" }

    before do
      allow(Geocoding::GeocodeAddress).to receive(:call).and_return("95014")
    #   allow(ENV).to receive(:[]).with("OPENWEATHER_API_KEY").and_return("k")
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("OPENWEATHER_API_KEY").and_return("k")
    end

    it "renders forecast and sets cache" do
      stub_request(:get, /api.openweathermap.org/).to_return(
        status: 200,
        body: {
          main: { temp: 20.1, temp_max: 23.5, temp_min: 18.2 },
          weather: [{ description: "clear sky" }]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

      post "/forecasts", params: { address: address }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Current:")
      expect(Rails.cache.exist?("forecast:zip:95014")).to be true
    end

    it "serves from cache on second call" do
      Rails.cache.write(
        "forecast:zip:95014",
        { current_temp_c: 21.0, high_c: 25.0, low_c: 19.0, summary: "sunny" },
        expires_in: 30.minutes
      )

      post "/forecasts", params: { address: address }
      expect(response.body).to include("served from cache")
    end

    it "shows a friendly message when ZIP cannot be resolved" do
        allow(Geocoding::GeocodeAddress).to receive(:call).and_return(nil)

        post "/forecasts", params: { address: "Some Unknown Place" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Could not resolve ZIP for that address.")
    end
  end
end
