# frozen_string_literal: true

class Pokemon < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  validates :hp,      numericality: { only_integer: true, in: 1..255 }
  validates :attack,  numericality: { only_integer: true, in: 1..255 }
  validates :defense, numericality: { only_integer: true, in: 1..255 }
  validates :sp_atk,  numericality: { only_integer: true, in: 1..255 }
  validates :sp_def,  numericality: { only_integer: true, in: 1..255 }
  validates :speed,   numericality: { only_integer: true, in: 1..255 }

  validates :generation, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  
  validates :legendary, inclusion: { in: [true, false] }
  validates :types,
            inclusion: { in: %w[Grass Poison Fire Flying Dragon Water Bug Normal Electric
                                Ground Fairy Fighting Psychic Rock Steel Ice Ghost Dark] },
            length: 1..2
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

  def calculate_total
    self.total = hp + attack + defense + sp_atk + sp_def + speed
  end

  def uniqueness_of_types
    errors.add(:types, 'must not contain duplicates') unless types.length == types.uniq.length
  end
end
