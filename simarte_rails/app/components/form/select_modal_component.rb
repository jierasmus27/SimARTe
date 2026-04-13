# frozen_string_literal: true

class Form::SelectModalComponent < ViewComponent::Base
  def initialize(form:, attribute:, selected_value:, options:, header: "Please select a value", search_query: nil)
    @form = form
    @attribute = attribute
    @selected_value = selected_value
    @options = options
    @header = header
    @search_query = search_query.presence
  end

  private

  attr_reader :form, :attribute, :selected_value, :options, :header, :search_query

  def field_name
    "#{@form.object_name}[#{@attribute}]"
  end

  def field_id
    "#{@form.object_name}_#{@form.object.id}_#{@attribute}"
  end
end
