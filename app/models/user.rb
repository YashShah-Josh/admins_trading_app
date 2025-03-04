class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,:jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :phone, presence: true, uniqueness: true, format: { with: /\A[6-9]\d{9}\z/, message: "must be a valid Indian mobile number" }
  validates :pan, presence: true, uniqueness: true, format: { with: /\A[A-Z]{5}[0-9]{4}[A-Z]\z/, message: "must be a valid PAN number" }
  validates :address, presence: true, length: { minimum: 10 }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
