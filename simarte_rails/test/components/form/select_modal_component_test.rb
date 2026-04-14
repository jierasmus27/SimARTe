# frozen_string_literal: true

require "test_helper"
require "view_component/test_case"

class Form::SelectModalComponentTest < ViewComponent::TestCase
  test "renders value-picker and modal-dialog wiring, hidden role field, and option values" do
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

    assert_selector "[data-controller='value-picker']"
    assert_selector "##{"user_#{users(:two).id}_role"}[name='user[role]'][value='user']", visible: :hidden
    assert_selector "[data-option-value='admin']"
    assert_selector "[data-option-value='user']"
    assert_selector "[data-action='click->value-picker#select click->modal-dialog#dismiss']"
  end
end
