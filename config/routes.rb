# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pokemons, constraints: { format: 'json' }, defaults: { format: 'json' }
end
