require "google_weather"
require "ferrety_ferret"

module Ferrety
  class WeatherFerret < Ferret

    def search(term, zip_code, low_threshold, high_threshold)
      todays_forecast = get_todays_forecast(zip_code)
      check_temp_ranges(todays_forecast, low_threshold, high_threshold)
      check_weather_conditions(todays_forecast, term)
      @alerts
    end

    private

    def get_todays_forecast(zip_code)
      GoogleWeather.new(zip_code).forecast_conditions.first
    end

    def check_temp_ranges(forecast, low_threshold, high_threshold)
      if forecast.low.to_i < low_threshold.to_i
        add_alert("Cold day! Low for the day is #{forecast.low}")
      end
      if forecast.high.to_i > high_threshold.to_i
        add_alert("Scorcher! High for the day is #{forecast.high}")
      end
    end

    def check_weather_conditions(forecast, term)
      if forecast.condition.upcase.scan(term.upcase).any?
        add_alert("Today's weather condition: #{forecast.condition}")
      end
    end
  end
end