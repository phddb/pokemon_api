# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

csv_string = File.read(Rails.root.join('lib', 'seeds', 'pokemon.csv'))
csv = CSV.parse(csv_string, headers: true)

# The "name" column in the .csv has some strangly formatted entries, 
#   e.g. "VenusaurMega Venusaur", "KyuremBlack Kyurem"
# This methods cleans them up by putting the general name at the front
#   and any more specific names in brackets
#   e.g. "Venusaur (Mega Venusaur)", "Kyurem (Black Kyurem)"
def sanitize_name str
  general_name, *specific_names = str.titleize.split(' ')

  # simple case, single name
  return general_name if specific_names.empty?

  # VenusaurMega Venusaur -> Venusaur (Mega Venusaur)
  "#{general_name} (#{specific_names.join ' '})"
end

# Squash two type columns into one
def sanitize_types t1, t2
  [ t1.presence, t2.presence ].compact
end

csv.each do |row|
  Pokemon.create(
    name:       sanitize_name(row['Name']),
    types:      sanitize_types(row['Type 1'], row['Type 2']),
    hp:         row['HP'],
    attack:     row['Attack'],
    defense:    row['Defense'],
    sp_atk:     row['Sp. Atk'],
    sp_def:     row['Sp. Def'],
    speed:      row['Speed'],
    generation: row['Generation'],
    legendary:  row['Legendary']
  )
end

