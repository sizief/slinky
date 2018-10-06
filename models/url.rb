require_relative './stat'

class Url < ActiveRecord::Base
  validates :shortcode, uniqueness: { message: "not_unique"}
  validates :url, presence: {message: "url_not_exist"}
  validates_format_of :shortcode, with: /\A[0-9a-zA-Z_]{6}\Z/i, message: "condition_failed"
  after_initialize :set_short_code
  has_many :stats

  def set_short_code
      self.shortcode ||= self.class.create_shortcode
  end

  def self.create_shortcode
     [*'0'..'9', *'a'..'z',*'A'..'Z',*'_'].sample(6).join.to_s
  end

end
