# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def [](attr)
      arel_table[attr]
    end
  end
end
