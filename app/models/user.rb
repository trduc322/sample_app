class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.valid_email_regex
  attr_accessor :remember_token
  has_secure_password
  validates :name, presence: true, length: { maximum: Settings.user.username_length }
  validates :email, presence: true, length: { maximum: Settings.user.email_username_length },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.user.password_min_length }, allow_nil: true
  before_save { self.email = email.downcase }
  def User.digest string
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create string, cost: cost
  end
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end
  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end
  def forget
    update_column :remember_digest, nil
  end
end
