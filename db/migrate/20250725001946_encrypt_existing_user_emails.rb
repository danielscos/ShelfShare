class EncryptExistingUserEmails < ActiveRecord::Migration[8.0]
  def up
    User.find_each do |user|
      if user.email.present? && !user.email.start_with?("ENCRYPTED:")
        # Store the real email temporarily
        real_email = user.email
        # Encrypt it using the same method as the model
        encrypted_data = simple_encrypt(real_email)
        encoded_email = "ENCRYPTED:#{Base64.encode64(encrypted_data).chomp}"
        user.update_column(:email, encoded_email)
      end
    end
  end

  def down
    # For security, don't decrypt emails when rolling back
    puts "Warning: Cannot decrypt emails during rollback for security reasons"
  end

  private

  ENCRYPTION_KEY = "shelf_share_secret_key_2024_very_secure_key_here"

  def simple_encrypt(text)
    text.bytes.map.with_index { |byte, i| byte ^ ENCRYPTION_KEY[i % ENCRYPTION_KEY.length].ord }.pack("C*")
  end
end
