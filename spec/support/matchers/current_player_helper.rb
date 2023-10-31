# frozen_string_literal: true

module RSpecHelpers
  module CurrentPlayerHelper
    def assign_current_player(player)
      allow_any_instance_of(Game::BaseController).to receive(:current_player).and_return(player) # rubocop:disable RSpec/AnyInstance
    end
  end
end
