require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A[A-Z0-9_]+\z/i

  before_validation :downcase_email
  before_validation :downcase_username

  has_many :questions, dependent: :delete_all

  validates :email, presence: true, format: { with: /\A.+@.+\z/}
  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX }
  validates :username, presence: true
  validates :username, length:{ within: 3..40 }
  validates :email, :username, uniqueness: true
  validates :profile_color, format: { with: /\A#([a-f\d]{3}){1,2}\z/ }

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  def downcase_email
    if email.present?
      self.email = self.email.downcase
    end
  end

  def downcase_username
    if username.present?
      self.username = self.username.downcase
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    return user if user.password_hash == hashed_password

    nil
  end
end
