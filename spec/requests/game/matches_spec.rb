# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Matches' do
  include RSpecHelpers::CurrentPlayerHelper

  let(:player) { create(:game_player, user: create(:user)) }
  let(:user) { player.user }
  let(:anonymous_player) { create(:game_player) }
  let(:match) { create(:game_match) }

  describe 'GET /game/matches' do
    before { match }

    it 'returns JSON with matches list' do
      get game_matches_path, as: :json
      expect(response.parsed_body).to include 'current_matches' => [a_hash_including('id' => match.id)]
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
    let(:match_params) { { game_match: { ruleset: 'english' } } }

    context 'without player' do
      it 'returns a successful response' do
        post game_matches_path, params: match_params, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'increases the count of game matches' do
        expect {
          post game_matches_path, params: match_params, as: :json
        }.to change(Game::Match, :count).by(1)
      end

      it 'creates a new player' do
        expect {
          post game_matches_path, params: match_params, as: :json
        }.to change(Game::Player, :count).by(1)
      end

      it 'associates the player with the match' do
        post game_matches_path, params: match_params, as: :json

        expect(Game::Match.last.white_player).to be_a Game::Player
      end
    end

    context 'with anonymous_player' do
      before { assign_current_player(anonymous_player) }

      it 'returns a successful response' do
        post game_matches_path, params: match_params, as: :json

        expect(response).to have_http_status(:success)
      end

      it 'creates a new match' do
        expect {
          post game_matches_path, params: match_params, as: :json
        }.to change(Game::Match, :count).by(1)
      end

      it 'assigns the white player as the anonymous player' do
        post game_matches_path, params: match_params, as: :json

        expect(Game::Match.last.white_player).to eq anonymous_player
      end
    end

    context 'with logged in user' do
      before { sign_in user }

      it 'returns a successful response' do
        post game_matches_path, params: match_params, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'creates a new match' do
        expect {
          post game_matches_path, params: match_params, as: :json
        }.to change(Game::Match, :count).by(1)
      end

      it 'sets correct white player for the match' do
        post game_matches_path, params: match_params, as: :json
        expect(Game::Match.last.white_player).to eq player
      end
    end
  end

  describe 'POST /game/matches/:id/move' do
    let(:match) { create(:game_match, white_player: player) }

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

        expect(response.parsed_body)
          .to include('errors' => ['code' => 'invalid_move', 'detail' => 'one of the moves is invalid'])
      end
    end
  end

  describe 'POST /game/matches/:id/join' do
    context 'without player' do
      it 'returns a successful response' do
        post join_game_match_path(match), as: :json
        expect(response).to have_http_status(:success)
      end

      it 'lets a player join the match' do
        expect {
          post join_game_match_path(match), as: :json
        }.to change { Game::Match.last&.black_player }.from(nil).to be_a(Game::Player)
      end
    end

    context 'with anonymous_player' do
      before { assign_current_player(anonymous_player) }

      it 'returns a successful response' do
        post join_game_match_path(match), as: :json
        expect(response).to have_http_status(:success)
      end

      it 'lets the anonymous player join the match' do
        expect {
          post join_game_match_path(match), as: :json
        }.to change { match.reload.black_player }.from(nil).to anonymous_player
      end
    end

    context 'with logged in user' do
      before { sign_in user }

      it 'returns a successful response' do
        post join_game_match_path(match), as: :json
        expect(response).to have_http_status(:success)
      end

      it 'lets the player join the match' do
        expect {
          post join_game_match_path(match), as: :json
        }.to change { match.reload.black_player }.from(nil).to player
      end
    end
  end
end
