# frozen_string_literal: true

class Admin::SidebarComponent < ViewComponent::Base
  include Rails.application.routes.url_helpers
  def initialize(current_path:)
    @current_path = current_path
  end

  private

  attr_reader :current_path

  def nav_class(path)
    if current_path == path
      "#{nav_class_base_classes} text-primary border-r-4 border-primary bg-gradient-to-r from-primary/10 to-transparent transition-all duration-300"
    else
      "#{nav_class_base_classes} text-on-surface/50 hover:bg-[#282d31] hover:text-primary group"
    end
  end

  def nav_class_base_classes
    "flex items-center gap-3 px-8 py-3 font-headline font-medium transition-all duration-300"
  end
end
