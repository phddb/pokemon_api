# frozen_string_literal: true

class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[show update destroy]
  before_action :validate_pagination_params, only: :index

  # GET /pokemons
  def index

    @pokemons = \
      Pokemon
      .all
      .page(params[:page]) # pagination functions from Kaminari gem
      .per(params[:per_page])

    #  Current the app returns "meta" info about pagination (current page, total pages)
    #  in the response body.
    #  Alternatively, we could also return it in headers like so:

    # response.headers['X-Current-Page'] = query.current_page
    # response.headers['X-Total-Pages'] = query.total_pages

    # Also, though the app currently only responds in JSON, we could add support for other response types with
    # the block below and a few other minor modifications elsewhere.
    #
    # respond_to do |format|
    #   format.json { render :index, status: :ok }
    #   format.xml  { render xml: @pokemons.map(&:attributes).to_xml }
    # end
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

  def validate_pagination_params

    errors = {}
    %i[page per_page].each do |p|
      errors[p] = ['must be a positive integer'] if params[p].present? && !params[p].to_i.positive?
    end
    render json: errors, status: :unprocessable_entity if errors.present?

  end
  
  # Only allow a list of trusted parameters through.
  def params_for_create
    params.require(:pokemon).permit(:name, :hp, :attack, :defense, :sp_atk, :sp_def, :speed, :generation, :legendary,
                                    types: [])
  end

  def params_for_update
    params_for_create
  end
end
