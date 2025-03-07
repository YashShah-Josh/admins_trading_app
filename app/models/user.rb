class User < ApplicationRecord
  # Devise authentication modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  # Associations
  has_many :user_stocks, dependent: :destroy
  has_many :stocks, through: :user_stocks

  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                    format: { with: VALID_EMAIL_REGEX, message: "is invalid" }

  validates :phone, presence: true, uniqueness: { case_sensitive: false }, 
                    format: { with: /\A[6-9]\d{9}\z/, message: "must be a valid Indian mobile number" }

  validates :pan, presence: true, uniqueness: true, 
                  format: { with: /\A[A-Z]{5}[0-9]{4}[A-Z]\z/, message: "must be a valid PAN number" }

  validates :address, presence: true, length: { minimum: 10 }

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  validates :password, presence: true, length: { minimum: 6 }, format: { with: /\A(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/, message: "must include at least one uppercase letter, one digit, and one special character" }, if: -> { new_record? || password.present? }


end
