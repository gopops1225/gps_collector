# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_819_010_644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'fuzzystrmatch'
  enable_extension 'plpgsql'
  enable_extension 'postgis'
  enable_extension 'postgis_tiger_geocoder'
  enable_extension 'postgis_topology'

  create_table 'geo_points', force: :cascade do |t|
    t.geography 'coords', limit: { srid: 4326, type: 'st_point', geographic: true }, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['coords'], name: 'index_geo_points_on_coords', using: :gist
  end
end
