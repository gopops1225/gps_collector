# frozen_string_literal: true

# This table is created to hold geographic point data

class CreateGeoPoint < ActiveRecord::Migration[6.1]
  def change
    create_table :geo_points do |t|
      t.st_point :coords, null: false, geographic: true

      t.index :coords, using: :gist
      t.timestamps
    end
  end
end
