# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_defaults
  before_action :set_locale
  # set_callback :logging_in_user, :before, :handle_guest_authorized

  private

    def gon_defaults
      return unless request.format.html?

      user             = current_or_guest_user(create: false)
      gon.current_user = serialize(user) if user
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

  # def handle_guest_authorized
  # end

    def serialize(model, **options)
      ActiveModelSerializers::SerializableResource.new(model, **options).as_json
    end
end
