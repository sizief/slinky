#!/usr/bin/env bash

bundle exec rake db:migrate
bundle exec ruby app.rb
