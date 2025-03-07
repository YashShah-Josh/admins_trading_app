require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:user_stocks).dependent(:destroy) }
    it { should have_many(:stocks).through(:user_stocks) }
  end

  describe "validations" do
    subject { FactoryBot.build(:user) } # Ensure uniqueness tests pass

    # Email validation
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("test@example.com").for(:email) }
    it { should_not allow_value("invalid-email", "user@.com", "@example.com", "user@example", "user@com").for(:email) }

    # Name validation
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it "rejects names with only spaces" do
      user = User.new(name: "   ")
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    # Phone number validation
    it { should validate_presence_of(:phone) }
    it { should validate_uniqueness_of(:phone).case_insensitive }
    it { should allow_value("9876543210").for(:phone) }
    it { should_not allow_value("12345", "987654321", "0123456789", "1234567890", "98765ABCD0").for(:phone) }

    # PAN validation
    it { should validate_presence_of(:pan) }
    it { should validate_uniqueness_of(:pan) }
    it { should allow_value("ABCDE1234F").for(:pan) }
    it { should_not allow_value("ABCDE12345", "1234ABCDE5", "ABCDE1234@", "abcdE1234F").for(:pan) }

    # Address validation
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_least(10) }
    it "rejects an address with only spaces" do
      user = User.new(address: "        ")
      user.valid?
      expect(user.errors[:address]).to include("can't be blank")
    end

    # Balance validation
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    it "allows a balance of 0" do
      user = FactoryBot.build(:user, balance: 0)
      expect(user).to be_valid
    end
    it "rejects a negative balance" do
      user = FactoryBot.build(:user, balance: -10)
      user.valid?
      expect(user.errors[:balance]).to include("must be greater than or equal to 0")
    end
  end

  describe "Devise authentication" do
    let(:user) { FactoryBot.create(:user, password: "Password@123", password_confirmation: "Password@123") }

    it "authenticates with a valid password" do
      expect(user.valid_password?("Password@123")).to be true
    end

    it "fails authentication with an incorrect password" do
      expect(user.valid_password?("WrongPassword")).to be false
    end

    it "does not allow short passwords" do
      user.password = "123"
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "requires a strong password" do
      user.password = "password"
      user.valid?
      expect(user.errors[:password]).to include("must include at least one uppercase letter, one digit, and one special character")
    end
  end

  describe "JWT authentication" do
    let(:user) { FactoryBot.create(:user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

    it "generates a valid JWT token" do
      expect(token).not_to be_nil
    end

    it "decodes the token correctly" do
      decoded_user = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
      expect(decoded_user.id).to eq(user.id)
    end
  end
end
