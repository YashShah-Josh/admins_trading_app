class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX, message: "is invalid" }
  validates :password,presence:true, length: {minimum:6}, format: { with: /\A(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/, message: "must include at least one uppercase letter, one digit, and one special character" }  
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
end
