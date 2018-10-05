class Url < ActiveRecord::Base
  validates :shortcode, uniqueness: { message: "not_unique"}
  validates_format_of :shortcode, with: /\A[0-9a-zA-Z_]{6}\Z/i, message: "condition_failed"
end
