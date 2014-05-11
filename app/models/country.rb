class Country < ActiveRecord::Base

  INDICATOR_NAMES = ["EH_AirQuality", "EH_HealthImpacts", "EH_WaterSanitation", "EV_Agriculture", "EV_BiodiversityHabitat", "EV_ClimateEnergy", "EV_Fisheries", "EV_Forests", "EV_WaterResources"]
  ISO_CODES = Country.pluck(:iso)
  YEARS = (2002..2012).to_a

  def self.countries_from_params(params)
    params['countries'] || []
  end

  def self.radar_chart(params)
    iso_codes = params['iso_codes'] || ISO_CODES
    indicator_names = params['indicators'] || INDICATOR_NAMES
    years = params['years'] || YEARS
    years.map do |year|  
      iso_codes.map do |iso_code|
        country = Country.find_by(year: year.to_s, iso: iso_code.upcase)
          {
            "year" => year.to_s,
            "data" => {
              "id" => iso_code.upcase,
              "name" => country.country,
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
    iso_codes = params['iso_codes']
    indicator_name = params['indicator']

    {
      "indicator" => indicator_name,
      "data" => line_graph_data(indicator_name, iso_codes)
    }
  end

  def self.line_graph_data(indicator_name, iso_codes)
    iso_codes.map do |iso_code|
      {
          "key" => iso_code.upcase,
          "values" => YEARS.map do |year|
            country = Country.find_by(year: year.to_s, iso: iso_code.upcase)
              {
                "year" => year.to_s,
                "value" => country.send(indicator_name)
              }
          end
        }
    end
  end

  def self.iso_code_list
    Country.pluck(:iso, :country).to_h
  end

  def self.country_list
    Country.pluck(:country, :iso).to_h
  end
end
