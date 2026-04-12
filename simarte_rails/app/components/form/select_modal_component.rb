# frozen_string_literal: true

class Form::SelectModalComponent < ViewComponent::Base
  def initialize(form:, attribute:, selected_value:, options:, header: "Please select a value")
    @form = form
    @attribute = attribute
    @selected_value = selected_value
    @options = options
    @header = header
  end

  private

  attr_reader :form, :attribute, :selected_value, :options, :header

  def field_name
    "#{@form.object_name}[#{@attribute}]"
  end

  def field_id
    "#{@form.object_name}_#{@form.object.id}_#{@attribute}"
  end
end
