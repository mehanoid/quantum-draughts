# frozen_string_literal: true

class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    gon.match = get_match.as_json
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

  def update
    respond_to do |format|
      if get_match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: get_match.errors, status: :unprocessable_entity }
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

  def possible_moves
    game = Game::GamePlay.new(get_match)
    render json: {cells: game.possible_moves(params[:from]).map(&:name)}
  end

  def move
    game = Game::GamePlay.new(get_match)
    game.move params[:moves]
    render json: {match: get_match.as_json}
  rescue Game::Move::InvalidMove
    render json: {match: get_match.as_json, error: 'Invalid move'}
  end

  private
    helper_method def get_match
      @get_match ||= Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      param = params.require(:match).permit(:boards)
      boards = JSON.parse param[:boards]
      param.merge(boards: boards)
    end
end
