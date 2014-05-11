class Country < ActiveRecord::Base

  INDICATOR_NAMES = ["EH_AirQuality", "EH_HealthImpacts", "EH_WaterSanitation", "EV_Agriculture", "EV_BiodiversityHabitat", "EV_ClimateEnergy", "EV_Fisheries", "EV_Forests", "EV_WaterResources"]
  COUNTRY_NAMES = Country.pluck(:country)
  YEARS = (2002..2012).to_a

  def self.countries_from_params(params)
    params['countries'] || []
  end

  def self.radar_chart(params)
    country_names = params['countries'] || COUNTRY_NAMES
    indicator_names = params['indicators'] || INDICATOR_NAMES
    years = params['years'] || YEARS
    years.map do |year|  
      country_names.map do |country_name|
        country = Country.find_by(year: year.to_s, country: country_name.downcase.capitalize)
          {
            "year" => year.to_s,
            "data" => {
              "id" => country.iso,
              "name" => country_name,
              "indicators" => country.indicators(indicator_names)
            }
          }
      end
    end
  end

  def indicators(indicator_names = INDICATOR_NAMES)
    indicator_names.map do |indicator|
      {"name" => indicator, "value" => send(indicator)}
    end
  end

  def self.line_graph(params)
    country_names = params['countries'].map { |name| name.downcase.capitalize }
    indicator_name = params['indicator']

    {
      "indicator" => indicator_name,
      "data" => line_graph_data(indicator_name, country_names)
    }
  end

  def self.line_graph_data(indicator_name, country_names)
    country_names.map do |country_name|
      YEARS.map do |year|
        country = Country.find_by(year: year.to_s, country: country_name.downcase.capitalize)
      {
          "id" => country.iso,
          "key" => country_name,
          "values" => {
            "year" => year.to_s,
            "value" => country.send(indicator_name)
          }
        }
      end
    end    

  end
end
