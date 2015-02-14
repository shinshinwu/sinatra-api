require 'securerandom'

class Token < ActiveRecord::Base
  belongs_to :user

  after_create :generate

  def generate
    token = SecureRandom.hex
    self.key = token
    self.save
  end
end
