require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "validations" do
    subject { FactoryBot.build(:admin) } # Ensures uniqueness validation works

    # Email validation
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("admin@example.com").for(:email) }
    it { should_not allow_value("invalid-email", "admin@.com", "@example.com", "admin@example", "admin@com").for(:email) }

    # Name validation
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it "rejects names with only spaces" do
      admin = Admin.new(name: "   ")
      admin.valid?
      expect(admin.errors[:name]).to include("can't be blank")
    end

    # Password validation (Devise uses `password`, not `encrypted_password`)
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }

    it "rejects passwords without an uppercase letter, digit, and special character" do
      invalid_passwords = ["password", "PASSWORD123", "password@", "Pass123"]

      invalid_passwords.each do |invalid_password|
        admin = Admin.new(password: invalid_password)
        admin.valid?
        expect(admin.errors[:password]).to include("must include at least one uppercase letter, one digit, and one special character")
      end
    end

    it "accepts a strong password" do
      admin = FactoryBot.build(:admin, password: "Secure@123")
      expect(admin.valid?).to be true
    end
  end

  describe "Devise authentication" do
    let(:admin) { FactoryBot.create(:admin, password: "Secure@123", password_confirmation: "Secure@123") }

    it "authenticates with a valid password" do
      expect(admin.valid_password?("Secure@123")).to be true
    end

    it "fails authentication with an incorrect password" do
      expect(admin.valid_password?("WrongPassword")).to be false
    end
  end
end
