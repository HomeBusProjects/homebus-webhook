require 'securerandom'

class Webhook < ApplicationRecord
  has_many :journals

  before_create :_set_path

  def _set_path
    while true do
      self.path = SecureRandom.base64(12)
      unless self.path.include? '/'
        return
      end
    end
  end
end
