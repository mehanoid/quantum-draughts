# frozen_string_literal: true

module Game
  class Player < ApplicationRecord
    belongs_to :user, optional: true

    before_validation :strip_name
    before_create :assign_uuid

    validates :displaying_name, length: { maximum: 25 }

    private

    def strip_name
      displaying_name&.strip!
    end

    def assign_uuid
      self.uuid = SecureRandom.uuid unless uuid
    end
  end
end
