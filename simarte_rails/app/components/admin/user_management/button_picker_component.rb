class Admin::UserManagement::ButtonPickerComponent < ViewComponent::Base
  def initialize(selected_value:, options:, header: 'Please select a value')
    @selected_value = selected_value
    @options = options
  end

  private

  attr_reader :selected_value, :options, :header
end
