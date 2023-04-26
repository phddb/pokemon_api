# frozen_string_literal: true

class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[show update destroy]

  # GET /pokemons
  def index

    @pokemons = \
      Pokemon
      .all
      .page(params[:page])      # pagination functions from Kaminari gem
      .per(params[:per_page])

    # At the moment we're returning "meta" info about pagination (current page, total pages)
    #  in the response body (rendered in views/pokemons/index.json.jbuilder).
    #  Alternatively, we could also return it in the response headers like so:

    # response.headers['X-Current-Page'] = query.current_page
    # response.headers['X-Total-Pages'] = query.total_pages

  end

  # GET /pokemons/1
  def show; end

  # POST /pokemons
  def create
    @pokemon = Pokemon.new params_for_create
    if @pokemon.save
      render :show, status: :created, location: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pokemons/1
  def update
    if @pokemon.update params_for_update
      render :show, status: :ok, location: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pokemons/1
  def destroy
    @pokemon.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def params_for_create
    params.require(:pokemon).permit(:name, :hp, :attack, :defense, :sp_atk, :sp_def, :speed, :generation, :legendary, types: [])
  end

  def params_for_update
    params_for_create
  end

end
