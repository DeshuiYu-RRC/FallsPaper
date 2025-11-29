class HealthController < ApplicationController
  def index
    render json: {
      status: "ok",
      timestamp: Time.current.iso8601,
      database: database_connected?,
      version: "1.0.0"
    }
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active? ? "connected" : "disconnected"
  rescue StandardError
    "disconnected"
  end
end
