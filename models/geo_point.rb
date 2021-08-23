# frozen_string_literal: true

class GeoPoint < ActiveRecord::Base
  def self.within_range(point, meters)
    where('ST_DWithin(coords, :point, :distance)', { point: point, distance: meters * 1000 })
  end

  def self.inside_polygon(polygon)
    where('ST_Covers(:polygon, coords)', polygon: polygon)
  end
end
