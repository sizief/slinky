require_relative './url'

class Stat < ActiveRecord::Base
  belongs_to :url

end
