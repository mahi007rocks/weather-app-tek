class ForecastsController < ApplicationController
  def index
    # Only the form for now; wiring comes later.
    @address = params[:address].to_s.strip.presence
  end
end
