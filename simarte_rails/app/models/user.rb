class User < ApplicationRecord
  has_paper_trail

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

  # Resolve a local user from Auth0 access token claims (`sub`, optional verified `email`).
  # Returns nil if no matching or linkable user (unknown Auth0 identity).
  def self.find_or_sync_from_auth0(claims)
    sub = claims["sub"].presence
    return nil if sub.blank?

    user = find_by(auth0_sub: sub)
    return user if user

    return nil unless claims["email_verified"] == true

    email = claims["email"].to_s.strip.downcase
    return nil if email.blank?

    existing = find_by("LOWER(email) = ?", email)
    return nil if existing.nil?
    return nil if existing.auth0_sub.present? && existing.auth0_sub != sub

    existing.update!(auth0_sub: sub)
    existing
  end
end
