class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_paper_trail

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :subscriptions, dependent: :destroy
  has_many :services, through: :subscriptions

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  enum :role, {
    user: 0,
    admin: 1
  }

  scope :search, lambda { |raw_q|
    q = raw_q.to_s.strip
    return all if q.blank?

    pattern = "%#{sanitize_sql_like(q)}%"
    base = left_joins(subscriptions: :service)

    name_or_email = base.where(
      "users.email ILIKE :p OR users.first_name ILIKE :p OR users.last_name ILIKE :p " \
      "OR CONCAT_WS(' ', users.first_name, users.last_name) ILIKE :p",
      p: pattern
    )

    by_service = base.where("services.name ILIKE :p", p: pattern)

    role_values = roles.select { |k, _| k.casecmp?(q) || k.start_with?(q.downcase) }.values

    combined = name_or_email.or(by_service)
    combined = combined.or(base.where(role: role_values)) if role_values.any?
    combined.distinct
  }

  def initials
    "#{first_name.to_s[0]}#{last_name.to_s[0]}".upcase
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
