require "google_weather"
require "ferrety_ferret"

module Ferrety
  class WeatherFerret < Ferret
    attr_accessor :zip, :term, :low_threshold, :high_threshold

    def initialize(params)
      super
      @zip = @params["zip"]
      @term = @params["term"]
      @low_threshold = @params["low_threshold"].to_i
      @high_threshold = @params["high_threshold"].to_i
    end

    def search
      check_temp_ranges
      check_weather_conditions
      @alerts
    end

    private

    def todays_forecast
      @forecast ||= GoogleWeather.new(@zip).forecast_conditions.first
    end

    def check_temp_ranges
      if todays_forecast.low.to_i < @low_threshold
        add_alert("Cold day! Low for the day is #{todays_forecast.low}")
      end
      if todays_forecast.high.to_i > @high_threshold
        add_alert("Scorcher! High for the day is #{todays_forecast.high}")
      end
    end

    def check_weather_conditions
      weather_condition = todays_forecast.condition
      if weather_condition.upcase.scan(@term.upcase).any?
        add_alert("Today's weather condition: #{weather_condition}")
      end
    end
  end
end