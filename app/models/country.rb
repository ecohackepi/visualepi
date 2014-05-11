class Country < ActiveRecord::Base

  INDICATOR_NAMES = ["EH_AirQuality", "EH_HealthImpacts", "EH_WaterSanitation", "EV_Agriculture", "EV_BiodiversityHabitat", "EV_ClimateEnergy", "EV_Fisheries", "EV_Forests", "EV_WaterResources"]
  COUNTRY_NAMES = Country.pluck(:country)
  YEARS = [2012]

  def self.countries_from_params(params)
    params['countries'] || []
  end

  def self.radar_chart(params)
    country_names = params['countries'] || COUNTRY_NAMES
    indicator_names = params['indicators'] || INDICATOR_NAMES
    years = params['years'] || YEARS
    country_names.map do |country_name|
      country = Country.find_by(country: country_name.downcase.capitalize)
        {
          "year" => "2012",
          "data" => {
            "id" => country.iso,
            "name" => country_name,
            "indicators" => country.indicators(indicator_names)
          }
        }
    end
  end

  def indicators(indicator_names = INDICATORS)
    indicator_names.map do |indicator|
      {"name" => indicator, "value" => send(indicator)}
    end
  end
end
