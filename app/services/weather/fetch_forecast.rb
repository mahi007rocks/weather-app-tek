require "http"

module Weather
  class FetchForecast
    # Returns { current_temp_c:, high_c:, low_c:, summary: } or nil.
    def self.call(zip)
      api_key = ENV["OPENWEATHER_API_KEY"]
      return nil if api_key.to_s.empty? || zip.to_s.strip.empty?

      url = "https://api.openweathermap.org/data/2.5/weather"
      resp = HTTP.timeout(5).get(url, params: { zip: zip, appid: api_key, units: "metric" })
      return nil unless resp.status.success?

      json = resp.parse
      {
        current_temp_c: json.dig("main", "temp"),
        high_c:         json.dig("main", "temp_max"),
        low_c:          json.dig("main", "temp_min"),
        summary:        json.dig("weather", 0, "description")
      }
    rescue StandardError => e
      Rails.logger.error("[FetchForecast] #{e.class}: #{e.message}")
      nil
    end
  end
end
