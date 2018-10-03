FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client ruby-dev
ENV APP_ROOT /var/www/slinky
WORKDIR $APP_ROOT
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler && bundle install
EXPOSE 4567
COPY . .

#RUN bundle exec rake db:migrate

#RUN ["chmod", "+x", "config/container.sh"]
#RUN ["chmod", "+x", "config/migrate.sh"]
CMD ["config/container.sh"] #.shruby app.rb
#CMD ["bundle","exec","rake", "db:create"]
#CMD ["bundle","exec","rake" ,"db:migrate"]
#CMD ["bundle","exec","ruby","app.rb"]
#CMD["rackup", "-s", "Puma", "-E", "production"]
