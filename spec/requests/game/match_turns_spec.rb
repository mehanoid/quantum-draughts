# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MatchTurns' do
  let(:match_turn) { create(:game_match).current_turn }

  describe 'GET /show' do
    it 'returns the requested match turn' do
      get game_match_turn_path(match_turn)

      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to include 'id' => match_turn.id
      expect(response.parsed_body).to include 'boards'
    end
  end
end
