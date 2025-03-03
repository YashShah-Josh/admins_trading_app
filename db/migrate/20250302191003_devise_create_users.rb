# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, default: ""
      t.string :phone
      t.string :encrypted_password, default: "", null: false
      t.string :password_digest
      t.float :balance, precision: 15, scale: 2
      t.text :address
      t.string :pan
      t.datetime :deleted_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :pan, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
