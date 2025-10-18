class ForecastsController < ApplicationController
  def index
    @address = params[:address].to_s.strip.presence
    return unless @address

    zip = Geocoding::GeocodeAddress.call(@address)
    unless zip
      flash.now[:alert] = "Could not resolve ZIP for that address."
      return
    end

    cache_key = "forecast:zip:#{zip}"
    from_cache = true
    data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      from_cache = false
      Weather::FetchForecast.call(zip)
    end

    unless data
      flash.now[:alert] = "No forecast available."
      return
    end

    @result = data.merge(zip:, from_cache:)
  end
end
