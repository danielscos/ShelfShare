class User < ApplicationRecord
  has_secure_password
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :location, presence: true

  before_save :encrypt_email_field
  after_find :decrypt_email_field

  def admin?
    admin == true
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end

  def encrypted_email_display
    "[ENCRYPTED]"
  end

  def real_email_for_owner
    @decrypted_email || email
  end

  private

  ENCRYPTION_KEY = "shelf_share_secret_key_2024_very_secure_key_here"

  def encrypt_email_field
    if email_changed? && email.present? && !email.include?("ENCRYPTED:")
      @decrypted_email = email
      self.email = "ENCRYPTED:#{Base64.encode64(simple_encrypt(email)).chomp}"
    end
  end

  def decrypt_email_field
    if email.present? && email.start_with?("ENCRYPTED:")
      encrypted_data = email.sub("ENCRYPTED:", "")
      @decrypted_email = simple_decrypt(Base64.decode64(encrypted_data)) rescue email
    else
      @decrypted_email = email
    end
  end

  def simple_encrypt(text)
    text.bytes.map.with_index { |byte, i| byte ^ ENCRYPTION_KEY[i % ENCRYPTION_KEY.length].ord }.pack("C*")
  end

  def simple_decrypt(encrypted_data)
    encrypted_data.bytes.map.with_index { |byte, i| byte ^ ENCRYPTION_KEY[i % ENCRYPTION_KEY.length].ord }.pack("C*")
  end
end
