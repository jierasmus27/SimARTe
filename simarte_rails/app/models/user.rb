class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :services, through: :subscriptions

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  def initials
    "#{first_name.to_s[0]}#{last_name.to_s[0]}".upcase
  end
end
