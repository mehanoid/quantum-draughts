# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_defaults

  private

  def gon_defaults
    return unless request.format.html?

    user = current_or_guest_user(create: false)
    gon.current_user = serialize(user) if user
  end

  def serialize(model, **options)
    ActiveModelSerializers::SerializableResource.new(model, **options).as_json
  end
end
