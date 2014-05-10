class Country < ActiveRecord::Base

  CATEGORIES = ["EH_AirQuality", "EH_HealthImpacts", "EH_WaterSanitation", "EV_Agriculture", "EV_BiodiversityHabitat", "EV_ClimateEnergy", "EV_Fisheries", "EV_Forests", "EV_WaterResources"]
  def self.new_from_params(params)
    year = params["year"]
    year = params["country"]
  end

  def self.radar_chart
    {
      "countries" => country_categories
    }
  end

  def self.country_categories
    all.map do |country|
      {
        "name" => country.iso,
        "categories" => country.categories
      }
    end
  end

  def categories
    CATEGORIES.map do |cat|
      {"name" => cat, "value" => send(cat)}
    end
  end
end
