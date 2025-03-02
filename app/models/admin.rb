class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
end
