# frozen_string_literal: true

class Pokemon < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # pokemon "stats" appear to have a range from 1-255, so apply this contstraint to our records
  # (https://bulbapedia.bulbagarden.net/wiki/Base_stats#In_the_core_series)
  validates :hp,        presence: true, numericality: { only_integer: true, in: 1..255 }
  validates :attack,    presence: true, numericality: { only_integer: true, in: 1..255 }
  validates :defense,   presence: true, numericality: { only_integer: true, in: 1..255 }
  validates :sp_atk,    presence: true, numericality: { only_integer: true, in: 1..255 }
  validates :sp_def,    presence: true, numericality: { only_integer: true, in: 1..255 }
  validates :speed,     presence: true, numericality: { only_integer: true, in: 1..255 }

  validates :generation, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates :types,
            presence: true,
            inclusion: { in: %w[Grass Poison Fire Flying Dragon Water Bug Normal Electric
                                Ground Fairy Fighting Psychic Rock Steel Ice Ghost Dark] },
            length: 1..2

  validates :legendary, inclusion: { in: [true, false] }
  validate :uniqueness_of_types

  # types is an array of strings. It will be serialized to YAML by default
  serialize :types

  # calculate total on demand when rendering views.
  # we're not indexing/searching on it, so there's no need to denormalize it and put it in its own database column
  def total
    hp + attack + defense + sp_atk + sp_def + speed
  end

  # Attribute_map maps attribute names to column names in the original .csv
  # Used in views/pokemons/_pokemon.json.jbuilder; also in tests
  Attributes_map = { name: 'Name', types: 'Types', total: 'Total', hp: 'HP', attack: 'Attack', defense: 'Defense',
                     sp_atk: 'Sp. Atk', sp_def: 'Sp. Def', speed: 'Speed', generation: 'Generation', legendary: 'Legendary' }.freeze

  private

  def uniqueness_of_types
    errors.add(:types, 'must not contain duplicates') unless types.length == types.uniq.length
  end
end
