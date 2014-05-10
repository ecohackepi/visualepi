class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def radar_chart
    respond_to do |f|
      f.json {render json: Country.radar_chart.to_json.html_safe }
    end
  end

  private
    def radar_chart_params
      permit("year", "country")
    end
end