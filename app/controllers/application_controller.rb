class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def radar_chart
    respond_to do |f|
      f.json {render json: Country.radar_chart(radar_chart_params).to_json.html_safe }
    end
  end

  private
    def radar_chart_params
      params.permit("countries" => [])
    end
end