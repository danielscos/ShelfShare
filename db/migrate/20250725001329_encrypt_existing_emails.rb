class EncryptExistingEmails < ActiveRecord::Migration[8.0]
  def up
    User.find_each do |user|
      if user.email.present? && user.encrypted_email.blank?
        user.update_column(:encrypted_email, user.email)
      end
    end
  end

  def down
    # Don't decrypt emails when rolling back for security
    # Users will need to re-enter emails if rolling back
  end
end
