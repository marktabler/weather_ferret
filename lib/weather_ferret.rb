require "google_weather"
require "ferrety_ferret"

module Ferrety
  class WeatherFerret < Ferret
    attr_accessor :zip, :term, :low_threshold, :high_threshold

    # If no high is specified, give it a ridiculously large number
    # so that it won't interpret as 0 and trigger on all positive temperatures.
    DEFAULT_HIGH = 1000
    
    def initialize(params)
      super
      @zip = @params["zip"]
      @term = @params["term"]
      @low_threshold = @params["low_threshold"].to_i
      @high_threshold = (@params["high_threshold"] || DEFAULT_HIGH).to_i
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

    def todays_low
      todays_forecast.low.to_i
    end

    def todays_high
      todays_forecast.high.to_i
    end

    def todays_condition
      todays_forecast.condition
    end

    def check_temp_ranges
      if todays_low < @low_threshold
        add_alert("Cold day! Low for the day is #{todays_low}")
      end
      if todays_high > @high_threshold
        add_alert("Scorcher! High for the day is #{todays_high}")
      end
    end

    def check_weather_conditions
      if @term && todays_condition.upcase.scan(@term.upcase).any?
        add_alert("Today's weather condition: #{todays_condition}")
      end
    end
  end
end