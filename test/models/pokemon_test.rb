# frozen_string_literal: true

require 'test_helper'

class PokemonTest < ActiveSupport::TestCase
  pokemon_hash = { name: 'test', types: %w[Grass Poison], hp: 1, attack: 1, defense: 1, sp_atk: 1, sp_def: 1,
                   speed: 1, generation: 1, legendary: false }

  test 'total stat should equal sum of other numeric stats' do
    p = Pokemon.create! pokemon_hash
    assert p.total == 6
  end

  %i[name hp attack defense sp_atk sp_def speed generation legendary].each do |k|
    test "#{k} should be present in order to save" do
      hash_without_one_field = pokemon_hash.except k
      assert_raises(ActiveRecord::RecordInvalid) do
        Pokemon.create! hash_without_one_field
      end
    end
  end

  test 'names should be unique' do
    Pokemon.create! pokemon_hash.merge({ name: 'duplicate_name' })
    assert_raises(ActiveRecord::RecordInvalid) do
      Pokemon.create! pokemon_hash.merge({ name: 'duplicate_name' })
    end
  end

  %i[hp attack defense sp_atk sp_def speed].each do |k|
    test "#{k} should be greater than or equal to 1" do
      assert_raises(ActiveRecord::RecordInvalid) do
        Pokemon.create! pokemon_hash.merge({ k => 0 })
      end
    end
  end

  %i[hp attack defense sp_atk sp_def speed].each do |k|
    test "#{k} should be less than or equal to 255" do
      assert_raises(ActiveRecord::RecordInvalid) do
        Pokemon.create! pokemon_hash.merge({ k => 256 })
      end
    end
  end

  test 'types should be members of allowed list of types' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Pokemon.create! pokemon_hash.merge({ types: ['Lightning'] })
    end
  end

  test 'types should not contain more than two types' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Pokemon.create! pokemon_hash.merge({ types: %w[Grass Poison Fire] })
    end
  end

  test 'types should not contain duplicates' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Pokemon.create! pokemon_hash.merge({ types: %w[Grass Grass] })
    end
  end
end
