# frozen_string_literal: true

require "test_helper"
require "view_component/test_case"

class Form::SelectModalComponentTest < ViewComponent::TestCase
  test "renders select-modal controller, hidden role field, and option values" do
    render_inline(Form::SelectModalComponent.new(
      form: ActionView::Helpers::FormBuilder.new(
        :user,
        users(:two),
        vc_test_controller.view_context,
        {}
      ),
      attribute: :role,
      selected_value: "user",
      options: User.roles.keys.sort,
      header: "Select Operational Role"
    ))

    assert_selector "[data-controller='select-modal']"
    assert_selector "input[type='hidden'][name='user[role]'][value='user']", visible: :hidden
    assert_selector "[data-option-value='admin']"
    assert_selector "[data-option-value='user']"
    assert_selector "[data-action='click->select-modal#selectOption']"
  end
end
