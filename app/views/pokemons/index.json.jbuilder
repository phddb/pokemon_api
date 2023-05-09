# frozen_string_literal: true

json.meta pagination_metadata(@pokemons)

json.data do
  json.array! @pokemons, partial: 'pokemons/pokemon', as: :pokemon
end
