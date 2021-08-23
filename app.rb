# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'rgeo-geojson'
require './models/geo_point'
require 'sinatra/flash'

set :database_file, './config/database.yml'
enable :sessions

get '/' do
  @points = points
  erb :app
end

get '/in_radius' do
  begin
    @radius_point = RGeo::GeoJSON.decode(params[:radius_point].squish)
    @points_in_radius = GeoPoint.within_range(@radius_point, params[:meters].to_i)
  rescue StandardError
    @points_in_radius = GeoPoint.where(id: -1)
  end
  @points = points
  erb :app
end

get '/within_polygon' do
  begin
    @polygon = RGeo::GeoJSON.decode(params[:polygon].squish)
    @points_within = GeoPoint.inside_polygon(@polygon)
  rescue StandardError
    @points_within = GeoPoint.where(id: -1)
  end
  @points = points
  erb :app
end

post '/create_point' do
  begin
    geo_hash = JSON.parse params[:geo_point].gsub('=>', ':')
    if geo_hash['type'].casecmp?('Point')
      GeoPoint.create(coords: RGeo::GeoJSON.decode(params[:geo_point].squish))
    elsif geo_hash['type'].casecmp?('GeometryCollection')
      create_point_from_collection(geo_hash)
    else
      raise 'Input not recognized'
    end
    flash[:alert] = 'Successfully Saved Point'
  rescue StandardError => e
    flash[:error] = "Could not Save Given Point! Error: #{e}"
  end
  redirect '/'
end

private

def points
  GeoPoint.all.order(created_at: :desc)
end

def create_point_from_collection(geo_hash)
  geo_hash['geometries'].each do |geo|
    GeoPoint.create(coords: RGeo::GeoJSON.decode(geo)) if geo['type'].casecmp?('Point')
  end
end
