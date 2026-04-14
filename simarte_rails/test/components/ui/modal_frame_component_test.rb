# frozen_string_literal: true

require "test_helper"
require "view_component/test_case"

class Ui::ModalFrameComponentTest < ViewComponent::TestCase
  test "glass variant renders overlay and panel shell" do
    render_inline(Ui::ModalFrameComponent.new(variant: :glass)) { "inner" }

    assert_selector ".fixed.inset-0.z-\\[100\\].flex.items-center.justify-center"
    assert_selector ".modal-blur.glass-panel.rounded-\\[24px\\]"
    assert_text "inner"
  end

  test "celestial variant renders overlay and panel shell" do
    render_inline(Ui::ModalFrameComponent.new(variant: :celestial)) { "body" }

    assert_selector ".backdrop-blur-sm"
    assert_selector ".celestial-blur.bg-surface-container\\/60"
    assert_text "body"
  end

  test "login variant without overlay renders panel only" do
    render_inline(Ui::ModalFrameComponent.new(variant: :login, with_overlay: false)) { "sign in" }

    assert_no_selector ".fixed.inset-0"
    assert_selector "[class*='glass-panel']"
    assert_text "sign in"
  end

  test "merges extra classes and data attributes" do
    render_inline(Ui::ModalFrameComponent.new(
      variant: :glass,
      overlay_extra_class: "hidden",
      overlay_html_attributes: { data: { foo: "bar" } },
      panel_html_attributes: { id: "panel-id" }
    )) { "x" }

    assert_selector "[data-foo='bar'].hidden"
    assert_selector "#panel-id"
  end
end
