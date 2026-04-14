# frozen_string_literal: true

class Ui::ModalDialogComponent < ViewComponent::Base
  renders_one :trigger_element
  renders_one :header
  renders_one :body
  renders_one :footer

  def initialize(title: "Please select a value", search_query: nil)
    @title = title
    @search_query = search_query.presence
  end

  private

  attr_reader :title, :search_query
end
