# frozen_string_literal: true

class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    gon.match = MatchSerializer.new(get_match).as_json
  end

  def new
    @match = Match.new
  end

  def edit
  end

  def create
    @match = Match.new
    @match.init_boards

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    get_match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def move
    game = Game::Gameplay.new(get_match)
    game.move params[:moves]
    render json: { match: MatchSerializer.new(get_match).as_json }
  rescue Game::InvalidMove => e
    render json: { match: MatchSerializer.new(get_match).as_json, error: "Invalid move: #{e.message}" }
  end

  private

    helper_method def get_match
      @get_match ||= Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      param  = params.require(:match).permit(:boards)
      boards = JSON.parse param[:boards]
      param.merge(boards: boards)
    end
end
