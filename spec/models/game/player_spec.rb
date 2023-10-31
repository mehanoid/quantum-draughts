# frozen_string_literal: true

require 'rails_helper'

module Game
  RSpec.describe Player do
    describe '#displaying_name' do
      context 'when it contains leading or trailing white spaces' do
        let(:player) { described_class.new(displaying_name: ' name ') }

        before { player.valid? }

        it 'is stripped' do
          expect(player.displaying_name).to eq('name')
        end
      end
    end

    describe 'uuid' do
      it 'assigns a uuid before create' do
        player = Game::Player.new
        expect(player.uuid).to be_nil
        player.save!
        expect(player.reload.uuid).to be_present
      end
    end
  end
end
