# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game::CurrentPlayers' do
  include RSpecHelpers::CurrentPlayerHelper
  let(:player) { create(:game_player) }

  describe 'GET /show' do
    context 'with existing player' do
      before { assign_current_player(player) }

      it 'returns a successful response' do
        get game_current_player_path
        expect(response).to have_http_status(:success)
      end

      it 'returns the current player in the response body' do
        get game_current_player_path
        expect(response.parsed_body).to include 'displaying_name' => player.displaying_name
      end
    end

    context 'with no player' do
      it 'returns a successful response' do
        get game_current_player_path
        expect(response).to have_http_status(:success)
      end

      it 'returns nothing' do
        get game_current_player_path
        expect(response.parsed_body).to be_nil
      end
    end
  end

  describe 'PUT /update' do
    let(:valid_attributes) do
      { player: { displaying_name: 'New Name' } }
    end

    context 'with existing player' do
      before { assign_current_player(player) }

      it "updates the requested player's displaying name" do
        expect {
          put game_current_player_path, params: valid_attributes
        }.to change { player.reload.displaying_name }.to 'New Name'
      end

      it 'returns successful response' do
        put game_current_player_path, params: valid_attributes
        expect(response).to have_http_status(:success)
      end
    end

    context 'with no player' do
      it 'creates new player' do
        expect {
          put game_current_player_path, params: valid_attributes
        }.to change(Game::Player, :count).by(1)
      end

      it 'returns successful response' do
        put game_current_player_path, params: valid_attributes
        expect(response).to have_http_status(:success)
      end

      it 'gives the new player the correct displaying name' do
        put game_current_player_path, params: valid_attributes
        player = Game::Player.last
        expect(player.displaying_name).to eq 'New Name'
      end
    end
  end
end
