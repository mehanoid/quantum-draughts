# frozen_string_literal: true

module Game
  class PlayerSerializer < ActiveModel::Serializer
    attributes :id, :displaying_name
  end
end
