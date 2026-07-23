class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  def self.create_guest!
    password = SecureRandom.hex(16)
    create!(email: "guest_#{SecureRandom.uuid}@example.com", password: password)
  end
end
