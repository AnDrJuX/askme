# Сделайте так, чтобы в базу юзернеймы пользователей попадали только
# в нижнем регистре. Например, если пользователь ввел vAsYA_2016, то в базе
#  он бы сохранялся, как vasya_2016
# Ваш код также должен гарантировать, что нельзя создать двух пользователей,
# с никами, отличающимися только регистром букв.
# Обязательно проверьте работоспособность кода в консоли.
# В качестве ответа приложите ссылку на репозиторий с приложением askme.
# Подсказка
# Используйте подходящий колбэк, так, чтобы на валидацию и в базу попадали
 # юзернеймы только в нижнем регистре.

require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A[A-Z0-9_]+\z/i

  before_validation :downcase_username

  has_many :questions

  validates :email, presence: true, format: { with: /\A.+@.+\z/}
  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX }
  validates :username, presence: true
  validates :username, length:{ within: 3..40 }
  validates :email, :username, uniqueness: true

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password
  # begin
    def downcase_username
      self.username = self.username.downcase
    end
  # rescue NoMethodError=>e
  #   nil # "Поля не должны быть пустые."
  # end

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
