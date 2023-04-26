# frozen_string_literal: true

Pokemon::Attributes_map.each do |model_key, view_key|
  json.set! view_key, pokemon.send(model_key)
end

json.extract! pokemon, :id, :created_at, :updated_at
json.url pokemon_url(pokemon, format: :json)
