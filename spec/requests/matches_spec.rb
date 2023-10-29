# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Matches' do
  let(:user) { create(:user) }
  let(:match) { create(:game_match) }

  describe 'GET /game/matches' do
    before { match }

    it 'works! (now write some real specs)' do
      get game_matches_path, as: :json
      expect(response.parsed_body).to include 'all_matches' => [a_hash_including('id' => match.id)]
    end
  end

  describe 'GET /game/matches/:id' do
    it 'returns JSON data of a specific match' do
      get game_match_path(match), as: :json

      expect(response).to have_http_status(:success)

      expect(response.parsed_body['id']).to eq match.id
      expect(response.parsed_body['current_player_color']).to eq 'white'
    end
  end

  describe 'POST /game/matches' do
    before { sign_in user }

    it 'creates a new match' do
      match_params = { game_match: { ruleset: 'english' } }

      expect {
        post game_matches_path, params: match_params, as: :json
      }.to change(Game::Match, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /game/matches/:id/move' do
    let(:match) { create(:game_match, white_player: user) }

    before { sign_in user }

    context 'with valid move' do
      let(:params) { { id: match.to_param, moves: [%w[C3 D4]] } }

      it 'makes a move in the match' do
        post move_game_match_path(match), params:, as: :json

        expect(response).to have_http_status(:success)
        expect(match.reload.match_turns.first.move).to eq [{ 'beat' => false, 'cells' => %w[C3 D4] }]
      end

      it 'sends match data to clients' do
        expect {
          post move_game_match_path(match), params:, as: :json
        }.to have_broadcasted_to(match).from_channel(Game::MatchChannel)
      end
    end

    context 'with invalid move' do
      let(:params) { { id: match.to_param, moves: [%w[C3 E5]] } }

      it 'does not change match' do
        expect {
          post move_game_match_path(match), params:, as: :json
        }.not_to change { match.current_turn.reload.boards }

        expect(response.parsed_body).to include('error' => 'Invalid move: one of the moves is invalid')
      end
    end
  end

  describe 'POST /game/matches/:id/join' do
    before { sign_in user }

    it 'allows a user to join the match' do
      post join_game_match_path(match), as: :json

      expect(response).to have_http_status(:success)
      expect(Game::Match.last.black_player).to eq(user)
    end
  end
end
