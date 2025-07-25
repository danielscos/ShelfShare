class User < ApplicationRecord
  has_secure_password
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :location, presence: true

  def admin?
    admin == true
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end

  def masked_email
    return "***@***.***" if email.blank?

    begin
      local, domain = email.split("@")
      return "***@***.***" unless local && domain

      # Mask local part: show first and last character, mask middle
      if local.length <= 2
        masked_local = "*" * local.length
      else
        masked_local = "#{local[0]}#{'*' * (local.length - 2)}#{local[-1]}"
      end

      # Mask domain: show first character and TLD
      domain_parts = domain.split(".")
      if domain_parts.length >= 2
        masked_domain_name = "#{domain_parts[0][0]}#{'*' * (domain_parts[0].length - 1)}"
        masked_domain = "#{masked_domain_name}.#{domain_parts[-1]}"
      else
        masked_domain = "#{domain[0]}#{'*' * (domain.length - 1)}"
      end

      "#{masked_local}@#{masked_domain}"
    rescue
      "***@***.***"
    end
  end

  def display_email_for_admin?
    false # Never show real emails, even to admins
  end
end
