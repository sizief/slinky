FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client ruby-dev
ENV APP_ROOT /var/www/slinky
WORKDIR $APP_ROOT
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler && bundle install
EXPOSE 4567
COPY . .
CMD ["config/container.sh"] #.shruby app.rb
