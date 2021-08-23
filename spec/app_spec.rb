# frozen_string_literal: true

require './app'
require 'rspec'
require 'rack/test'

def app
  Sinatra::Application
end

RSpec.describe 'The GPS Collector App' do
  include Rack::Test::Methods
  
  before :each do
    GeoPoint.destroy_all
  end

  it 'Successfully loads home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'Accepts point and distance in meters and gathers points within' do
    point = { "type": 'Point', "coordinates": [89.3, 34.7] }
    meters = 100
    params = { point: point, meters: meters }
    get '/in_radius', params
    expect(last_response).to be_ok
    GeoPoint.create(coords: RGeo::GeoJSON.decode({ "type": 'Point', "coordinates": [89.4, 34.7] }.to_json))
    expect(GeoPoint.within_range(RGeo::GeoJSON.decode(point.to_json), meters).count).to eq 1
  end

  it 'Accepts polygon and gathers points within' do
    polygon = { "type": 'Polygon', "coordinates": [
      [
        [100.0, 0.0],
        [101.0, 0.0],
        [101.0, 1.0],
        [100.0, 1.0],
        [100.0, 0.0]
      ]
    ] }
    params = { polygon: polygon }
    get '/within_polygon', params
    expect(last_response).to be_ok
    GeoPoint.create(coords: RGeo::GeoJSON.decode({ "type": 'Point', "coordinates": [100.0, 0.0] }.to_json))
    expect(GeoPoint.inside_polygon(RGeo::GeoJSON.decode(polygon.to_json)).count).to eq 1
  end

  it 'creates point from single point input' do
    params = { geo_point: { "type": 'Point', "coordinates": [89.3, 34.7] }.to_json }
    post '/create_point', params
    expect(last_response).to be_redirect
    follow_redirect!
    expect(GeoPoint.last.coords.as_text).to eq RGeo::GeoJSON.decode({ "type": 'Point',
                                                                      "coordinates": [89.3, 34.7] }.to_json).as_text
  end

  it 'creates point from geometry collection' do
    geo_hash = { "type": 'GeometryCollection',
                 "geometries": [{
                   "type": 'Point',
                   "coordinates": [99.0, 50.0]
                 }, {
                   "type": 'LineString',
                   "coordinates": [[101.0, 0.0], [102.0, 1.0]]
                 }] }
    params = { geo_point: geo_hash.to_json }
    post '/create_point', params
    expect(last_response).to be_redirect
    follow_redirect!
    expect(GeoPoint.last.coords.as_text).to eq RGeo::GeoJSON.decode({ "type": 'Point',
                                                                      "coordinates": [99.0, 50.0] }.to_json).as_text
  end
end
