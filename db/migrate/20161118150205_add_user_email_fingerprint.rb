class AddUserEmailFingerprint < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :email_fingerprint, :string, default: ''
    add_column :users, :encrypted_email, :text, default: ''
    encrypt_user_emails
    change_column_null :users, :email_fingerprint, false
    change_column_null :users, :encrypted_email, false
    remove_column :users, :email
  end

  def down
    add_column :users, :email, :string
    add_index :users, :email, unique: true
    decrypt_user_emails
    change_column_null :users, :email, false
    remove_column :users, :email_fingerprint
    remove_column :users, :encrypted_email
  end

  def encrypt_user_emails
    User.where(encrypted_email: '').each do |user|
      ee = EncryptedEmail.new_from_email(user.email)
      # must use raw SQL here to change data during the migration transaction.
      execute "UPDATE users SET encrypted_email='#{ee.encrypted}', email_fingerprint='#{ee.fingerprint}' WHERE id=#{user.id}"
    end
  end

  def decrypt_user_emails
    User.where(email: nil).each do |user|
      ee = EncryptedEmail.new(user.encrypted_email)
      user.update!(email: ee.decrypted)
    end
  end
end