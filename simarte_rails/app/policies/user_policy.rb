# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def update?
    user.admin? && !demoting_self_admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.none
      end
    end
  end

  private

  def demoting_self_admin?
    user == record &&
      record.will_save_change_to_role? &&
      record.role_was == "admin" &&
      record.user?
  end
end
