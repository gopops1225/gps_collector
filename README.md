# GPS COLLECTOR

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
The repo is to stand up a simple Ruby/Rack application backed by a
Postgres/PostGIS database. This app will accept a GeoJSON Point object
or Geometry collection and save that into the database. Also, this app
will accept a GeoJSON Point object and a radius distance(in meters) and
return points within that radius that are saved in the database. Lastly,
app will accept a GeoJSON Polygon and display saved points found inside
that polygon.
Note: The app is set to show only 15 but it will display correct number of
points

## Technologies
Project is created with:
* RUBY version: 3.0.0
* DOCKER version: 20.10.8

## Setup
To run this project:

cd into repo directory

```
$ docker-compose up -d db test_db
$ docker-compose up web
```
docker exec into web container bash

```
$ docker ps
$ docker exec -it <container_id> bash
gps_collector# rake db:migrate
(For testing)
gps_collector# rake db:migratee RACK_ENV=test
```
