Geocoder.configure(
  timeout: 5,
  use_https: true,
  # Defaults to :nominatim. For higher reliability, switch to Google/Mapbox:
  # lookup: :google, api_key: ENV["GOOGLE_GEOCODING_API_KEY"],
  # lookup: :mapbox, api_key: ENV["MAPBOX_TOKEN"],
)
