# frozen_string_literal: true

require 'test_helper'

class PokemonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pokemon = pokemons(:one)
    @pokemon_hash = { name: 'test', types: %w[Grass Poison], hp: 1, attack: 1, defense: 1, sp_atk: 1, sp_def: 1,
                      speed: 1, generation: 1, legendary: false }
  end

  test 'should return paginated index' do
    # destroy fixture pokemon and create 50 fresh ones
    Pokemon.destroy_all
    (1..50).each do |i|
      Pokemon.create @pokemon_hash.merge({ name: i, id: i })
    end

    get pokemons_url(page: 1, per_page: 10)
    assert JSON.parse(response.body)['data'].length == 10, "paginated index doesn't return right number of pokemons"
    assert JSON.parse(response.body)['data'].pluck('id') == (1..10).to_a,
           "paginated index doesn't return correct pokemons"
    assert_response :success

    get pokemons_url(page: 4, per_page: 5)
    assert JSON.parse(response.body)['data'].length == 5, "paginated index doesn't return right number of pokemons"
    assert JSON.parse(response.body)['data'].pluck('id') == [16, 17, 18, 19, 20],
           "paginated index doesn't return correct pokemons"
    assert_response :success

    etag = response.headers['ETag']
    get pokemons_url(page: 4, per_page: 5), headers: { 'HTTP_IF_NONE_MATCH' => etag }
    assert_response :not_modified, "Doesn't send 304 (not modified) when response hasn't been modified"
    assert response.body.empty?, "Sends a non-empty body when response hasn't been modified"

    get pokemons_url
    assert JSON.parse(response.body)['data'].length == 25, "paginated index doesn't default to 25 results per page"
    assert JSON.parse(response.body)['meta']['current_page'] == 1, "paginated index doesn't default to page 1"

    get pokemons_url(page: 'one', per_page: 10)
    assert_response :unprocessable_entity
    assert JSON.parse(response.body) == { 'page' => ['must be a positive integer'] },
           "422 isn't sent for invalid pagination params"

    get pokemons_url(page: 1, per_page: -10)
    assert_response :unprocessable_entity
    assert JSON.parse(response.body) == { 'per_page' => ['must be a positive integer'] },
           "422 isn't sent for invalid pagination params"
  end

  test 'should create pokemon' do
    assert_difference('Pokemon.count') do
      p = post pokemons_url, params: @pokemon_hash
    end

    assert_response :created

    # check that the response body matches params we sent
    resp = JSON.parse(response.body)
    Pokemon::Attributes_map.except(:total).each do |model_key, view_key|
      assert resp[view_key] == @pokemon_hash[model_key],
             "Field in response body, \"#{view_key} (#{resp[view_key]})\", doesn't match field passed to server \"#{model_key}: (#{@pokemon_hash[model_key]})\"."
    end

    # check that newly created database record matches params we sent
    db_pokemon = Pokemon.find_by(name: @pokemon_hash[:name])
    Pokemon::Attributes_map.keys.without(:total).each do |model_key|
      assert db_pokemon[model_key] == @pokemon_hash[model_key],
             "Field in newly created record, \"#{model_key} (#{db_pokemon[model_key]})\", doesn't match field passed to server \"#{model_key}: (#{@pokemon_hash[model_key]})\"."
    end
  end

  test 'should show pokemon' do
    get pokemon_url(@pokemon)

    assert_response :success

    # check that the response body matched the pokemon created by our fixture
    resp = JSON.parse(response.body)
    Pokemon::Attributes_map.except(:total).each do |model_key, view_key|
      assert resp[view_key] == @pokemon[model_key],
             "Incorrect value in response body: \"#{view_key} (#{resp[view_key]})\" doesn't match fixture value \"#{model_key}: (#{@pokemon[model_key]})\"."
    end

    # The test environment should raise a RecordNotFound exception here.
    # In the development and production environments this exception will be
    # caught and converted to a 404 response
    assert_raise(ActiveRecord::RecordNotFound, "Doesn't return 404 Not Found for invalid id") do
      get '/pokemons/0'
      assert_response :not_found
    end
  end

  test "should send 304 not modified if index response hasn't changed" do
    # send inital GET just to get ETag value
    get pokemon_url(@pokemon)
    etag = response.headers['ETag']

    # send second GET with last ETag
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

  test 'should update pokemon' do
    update_values = { name: 'test2', types: ['Grass'], hp: 2, attack: 2, defense: 2, sp_atk: 2, sp_def: 2, speed: 2,
                      generation: 2, legendary: true }

    %i[json xml url_encoded_form multipart_form].each do |mimetype|
      patch pokemon_url(@pokemon), params: update_values, as: mimetype
      assert :success, "Updated failed when params were sent encoded as #{mimetype}"
    end

    # independently update each attribute, check that result in correctly persisted to database
    update_values.each_key do |attribute_to_update|
      # create a fresh pokemon before each request
      Pokemon.destroy_all
      pre_patch = Pokemon.create(@pokemon_hash)

      # get snapshot of the new pokemon before we send patch request
      pre_patch_hash = pre_patch.as_json

      # send request to modify a single attribute
      patch pokemon_url(pre_patch), params: update_values.slice(attribute_to_update)

      assert_response :success

      # get snapshot of the same pokemon after the patch request
      post_patch = Pokemon.find(pre_patch.id)

      # assert that only the single attribute we wanted to update has changed
      Pokemon::Attributes_map.keys.without(:total).each do |model_key|
        if model_key == attribute_to_update
          assert post_patch[model_key] == update_values[model_key],
                 "Failed to update attribute \"#{model_key}\". Was #{pre_patch_hash[model_key.to_s]} but is now #{post_patch[model_key]}."
        else
          assert post_patch[model_key] == pre_patch_hash[model_key.to_s],
                 "Attribute changed when it shouldn't have been. \"#{model_key}\" was #{pre_patch_hash[model_key.to_s]} but is now #{@pokemon[model_key]}."
        end
      end
    end
  end

  test 'should destroy pokemon' do
    assert_difference('Pokemon.count', -1) do
      delete pokemon_url(@pokemon)
    end

    assert_response :no_content
  end
end
