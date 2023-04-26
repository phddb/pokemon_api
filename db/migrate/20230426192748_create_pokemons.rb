# frozen_string_literal: true

class CreatePokemons < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false

      t.string  :types, array: true, default: [].to_yaml, null: false
      t.integer :hp, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :sp_atk, null: false
      t.integer :sp_def, null: false
      t.integer :speed, null: false
      t.integer :generation, null: false
      t.boolean :legendary, null: false

      # an index isn't necessary for performance reasons (with this small
      #   dataset), but its included to enforce the uniqueness constraint on
      #   :name at the database level
      t.index :name, unique: true

      t.timestamps
    end
  end
end
