# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :name, default: "Admin", null: false
      t.string :email, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :role, default: "admin"
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.timestamps null: false
    end

    add_index :admins, :email, unique: true
    add_index :admins, :reset_password_token, unique: true
    add_index :admins, :confirmation_token, unique: true
  end
end
