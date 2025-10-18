module Geocoding
  class GeocodeAddress
    # Returns ZIP/postal code or nil.
    def self.call(address)
      return nil if address.to_s.strip.empty?

      result = Geocoder.search(address).first
      result&.postal_code&.strip
    rescue StandardError => e
      Rails.logger.error("[GeocodeAddress] #{e.class}: #{e.message}")
      nil
    end
  end
end
