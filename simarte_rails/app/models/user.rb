class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :services, through: :subscriptions

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  enum :role, {
    user: 0,
    admin: 1
  }

  def initials
    "#{first_name.to_s[0]}#{last_name.to_s[0]}".upcase
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
