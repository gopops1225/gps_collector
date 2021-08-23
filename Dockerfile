FROM ruby:3.0.0

WORKDIR /gps_collector
COPY Gemfile /gps_collector/Gemfile
COPY Gemfile.lock /gps_collector/Gemfile.lock
RUN bundle install
COPY . /gps_collector

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
