# frozen_string_literal: true

json.meta do
  json.current_page @pokemons.current_page
  json.total_pages @pokemons.total_pages
end

json.data do
  json.array! @pokemons, partial: 'pokemons/pokemon', as: :pokemon
end
