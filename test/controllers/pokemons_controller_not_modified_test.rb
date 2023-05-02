# frozen_string_literal: true

require 'test_helper'

class PokemonsControllerNotModifiedTest < ActionDispatch::IntegrationTest
  
  setup do
    @pokemon = pokemons(:one)
  end

  test "should send 304 not modified if show response hasn't changed" do
    # send inital GET just to get ETag value
    get pokemon_url(@pokemon)
    etag = response.headers['ETag']

    # send second GET with last ETag in HTTP_IF_NONE_MATCH header
    get pokemon_url(@pokemon), headers: { 'HTTP_IF_NONE_MATCH' => etag }

    assert_response :not_modified, "Doesn't send 304 (not modified) when resource hasn't been modified"
    assert response.body.empty?, "Sends a non-empty body when resource hasn't been modified"

    # modify the resource (touch updates "updated_at")
    @pokemon.touch

    # save ETag from last GET
    etag2 = response.headers['ETag']

    get pokemon_url(@pokemon), headers: { 'HTTP_IF_NONE_MATCH' => etag2 }
    assert_response :success, "Does't sent 200 (success) if resource has been modified."
  end

  test "should send 304 not modified if index response hasn't changed" do
    # first request is just to get ETag
    get pokemons_url
    etag = response.headers['ETag']

    # in this request, include ETag in HTTP_IF_NONE_MATCH header
    get pokemons_url, headers: { 'HTTP_IF_NONE_MATCH' => etag }
    assert_response :not_modified, "Doesn't send 304 (not modified) when response hasn't been modified"
    assert response.body.empty?, "Sends a non-empty body when response hasn't been modified"
  end

end
