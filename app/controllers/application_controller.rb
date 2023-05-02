# frozen_string_literal: true

class ApplicationController < ActionController::API
  
  # Automatically nest params under the resource name when they're processed by a controller
  #   i.e. turn 'bare' params like {'name': 'bulbasaur', 'hp': 45} 
  #        into nested params like {'pokemon': {'name': 'bulbasaur', 'hp': 45}} 
  # This nesting is a convention in Rails. Scaffolded StrongParameters don't work properly without it. 
  #
  # By default, Rails will 'wrap' params for :json and :xml but not for other Content-Types.
  # Here we turn on wrapping for 'application/x-www-form-urlencoded' and 'multipart/form-data', 
  # two content types that are easy to send from Postman.
  #
  # The line below lets the app accept 'bare' param requests from Postman encoded by 
  # all four mime types instead of just the first two.
  #
  # i.e. Not just :json
  #   curl --location --request PATCH 'localhost:3000/pokemons/1' \
  #     --header 'Content-Type: application/json' \
  #     --data ' { "name": "bulbasaur2"}
  #
  #  But also :url_encoded_form
  #   curl --location --request PATCH 'localhost:3000/pokemons/1' \
  #     --header 'Content-Type: application/x-www-form-urlencoded' \
  #     --data-urlencode 'name=bulbasaur2'

  wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
  


  # When required parameters are missing, strong params will throw an exception.
  #  Catch it here and send :bad_request (400) to client
  rescue_from ActionController::ParameterMissing do
    render nothing: true, status: :bad_request
  end
end
 